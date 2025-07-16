extends Node

enum Message{
	id,
	join,
	userConnected,
	userDisconnected,
	lobby,
	candidate,
	offer,
	answer,
	checkIn
}

var peer = WebSocketMultiplayerPeer.new()
var id = 0
var rtcPeer:WebRTCMultiplayerPeer = WebRTCMultiplayerPeer.new()
var hostId:int
var lobbyValue = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.connected_to_server.connect(RTCServerConnected)
	multiplayer.peer_connected.connect(RTCPeerConnected)
	multiplayer.peer_disconnected.connect(RTCPeerDisonnected)
	pass # Replace with function body.
func RTCServerConnected():
	print("RTC server connected")
func RTCPeerConnected(id):
	print("RTC peer connected " + str(id))
func RTCPeerDisonnected(id):
	print("RTC peer disconnected " + str(id))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
			if data.message == Message.id:
				id = data.id
				connected(id)
				print("My id is: " + str(id))
				
			if data.message == Message.userConnected:
				#GameManager.Players[data.id] = data.player	
				createPeer(data.id)
				
			if data.message == Message.lobby:
				hostId = data.host
				lobbyValue = data.lobbyValue
				GameManager.Players = JSON.parse_string(data.players)
				
			if data.message == Message.candidate:
				if rtcPeer.has_peer(data.orgPeer):
					print("Got candidate " + str(data.orgPeer) + "my id is " + str(self.id))
					rtcPeer.get_peer(data.orgPeer).connection.add_ice_candidate(data.mid, int(data.index), data.sdp)
			if data.message == Message.offer:
				if rtcPeer.has_peer(data.orgPeer):
					rtcPeer.get_peer(data.orgPeer).connection.set_remote_description("offer", data.data)
			if data.message == Message.answer:
				if rtcPeer.has_peer(data.orgPeer):
					rtcPeer.get_peer(data.orgPeer).connection.set_remote_description("answer", data.data)

func connected(id):
	rtcPeer.create_mesh(id)
	multiplayer.multiplayer_peer = rtcPeer

# webrtc connection stuff
func createPeer(id):
	if id != self.id:
		var peer:WebRTCPeerConnection = WebRTCPeerConnection.new()
		peer.initialize({
			"iceServers" : [{"urls": ["stun:stun.l.google.com:19302"]}]
		})
		print("binding id: " + str(id) + "my id is: " + str(self.id))
		
		peer.session_description_created.connect(self.offerCreated.bind(id))
		peer.ice_candidate_created.connect(self.iceCandidateCreated.bind(id))
		rtcPeer.add_peer(peer, id)
		
		if id < rtcPeer.get_unique_id():
			peer.create_offer()
		
	pass
func offerCreated(type, data, id):
	if not rtcPeer.has_peer(id):
		return
	
	rtcPeer.get_peer(id).connection.set_local_description(type, data)
	if type == "offer":
		sendOffer(id, data)
	else:
		sendAnswer(id, data)

func sendOffer(id, data):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.offer,
		"data" : data,
		"Lobby" : lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
func sendAnswer(id, data):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.answer,
		"data" : data,
		"Lobby" : lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	
func iceCandidateCreated(midName, indexName, sdpName, id):
	var message = {
		"peer" : id,
		"orgPeer" : self.id,
		"message" : Message.candidate,
		"mid" : midName,
		"index" : indexName,
		"sdp" : sdpName,
		"Lobby" : lobbyValue
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass

func connectToServer(ip):
	var resp = peer.create_client("ws://159.54.178.76:8915")
	if resp == OK:
		print("Client created successfully")
	else:
		print("Error creating client: ", resp)
	print("started client")
	


func _on_start_client_button_down() -> void:
	connectToServer("")
	pass # Replace with function body.


func _on_button_button_down() -> void:
	ping.rpc()
	pass # Replace with function body.
@rpc("any_peer", "call_local")
func ping():
	print("ping from " + str(multiplayer.get_remote_sender_id()))
	get_tree().change_scene_to_file("res://multiplayer_test.tscn")

func _on_join_lobby_button_down() -> void:
	var message = {
		"id" : id,
		"message" : Message.lobby,
		"name" : "",
		"lobbyValue" : $LineEdit.text
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass # Replace with function body.
