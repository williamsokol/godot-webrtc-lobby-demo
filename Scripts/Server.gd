class_name Server
extends Node

var Message = Multiplayer.Message

var peer = WebSocketMultiplayerPeer.new() 
var users = {}
var lobbies:Dictionary = {}

var Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
@export var hostPort = 8915
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "--server" in OS.get_cmdline_args():
		print("hosting on " + str(hostPort))
		peer.create_server(hostPort)
	peer.connect("peer_connected", peer_connected)
	peer.connect("peer_disconnected", peer_disconnected)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	peer.poll()
	if peer.get_available_packet_count() > 0:
		var packet = peer.get_packet()
		if packet != null:
			var dataString = packet.get_string_from_utf8()
			var data = JSON.parse_string(dataString)
			print(data)
			
			if data.message == Message.lobby:
				JoinLobby(data)
			if data.message == Message.exitLobby:
				ExitLobby(data)
			if data.message == Message.offer || data.message == Message.answer || data.message == Message.candidate:
				print("source id is " + str(data.orgPeer))
				sendToPlayer(data.peer,data)
			if data.message == Message.getLobbies:
				var serialziedLobbies:Dictionary = {}
				for i in lobbies:
					serialziedLobbies[i] = var_to_str(lobbies[i]) 
				var message = {
					"message" : Message.getLobbies,
					"lobbies" : var_to_str(lobbies) 
				}
				sendToPlayer(data.orgPeer,message)
				pass
	pass

func peer_connected(id):
	print("Peer connected " + str(id))
	users[id] = {
		"id" : id,
		"message" : Message.id
	}
	peer.get_peer(id).put_packet(JSON.stringify(users[id]).to_utf8_buffer())
	pass
func peer_disconnected(id):
	pass

func JoinLobby(user):
	var result = ""
	if user.lobbyValue == "":
		user.lobbyValue = generateRandomString()
		lobbies[user.lobbyValue] = Lobby.new(user.id, user.lobbyValue)
		print(user.lobbyValue) 
	var player = lobbies[user.lobbyValue].AddPlayer(user.id, user.name)
	
	for p in lobbies[user.lobbyValue].Players:
		
		var data = {
			"message" : Message.userConnected,
			"id" : user.id,
		}
		sendToPlayer(p, data)
		var data2 = {
			"message" : Message.userConnected,
			"id" : p,
		}
		sendToPlayer(user.id, data2)
		
		var lobbyInfo = {
			"message" : Message.lobby,
			"players" : JSON.stringify(lobbies[user.lobbyValue].Players),
			"host" : lobbies[user.lobbyValue].HostID,
			"lobbyValue" : user.lobbyValue,
		}
		sendToPlayer(p,lobbyInfo)
	
	var data = {
		"message" : Message.userConnected,
		"id" : user.id,
		"host" : lobbies[user.lobbyValue].HostID,
		"player" : lobbies[user.lobbyValue].Players[int(user.id)],
		"lobbyValue" : user.lobbyValue
	}
	sendToPlayer(user.id,data)

func ExitLobby(user):
	var lobby:Lobby = lobbies[user.lobbyValue]
	lobby.Players.erase(int(user.id))
	if(lobby.Players.size() == 0):
		print("Closing Lobby")
		lobbies.erase(lobby.LobbyValue)
	else:
		lobby.HostID = lobby.Players[lobby.Players.keys()[0]].id
	
	pass

func sendToPlayer(userId,data):
	peer.get_peer(userId).put_packet(JSON.stringify(data).to_utf8_buffer())
	
		
func generateRandomString():
	var result = ""
	for i in range(32):
		var index = randi() % Characters.length()
		result += Characters[index]
	return result

func startServer():
	if(peer.get_connection_status() != peer.CONNECTION_DISCONNECTED):
		print("your ws server is already running")
		return
	peer.create_server(8915)
	print("started Server")
	


func _on_start_server_button_down() -> void:
	startServer()
	pass # Replace with function body.


func _on_button_2_button_down() -> void:
	var message = {
		"message" : Message.id,
		"data" : "test from server"
	}
	peer.put_packet(JSON.stringify(message).to_utf8_buffer())
	pass # Replace with function body.
