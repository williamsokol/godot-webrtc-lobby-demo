extends Node

enum Message{
	id,
	joinLobby,
	exitLobby,
	getNewLobbyHost,
	userConnected,
	userDisconnected,
	lobby,
	getLobbies,
	candidate,
	offer,
	answer,
	checkIn
}

var is_host = false
var extrernal_oid = ""

func _ready() -> void:
	pass
	
func host():
	print("Hosting")
	
	var peer = ENetMultiplayerPeer.new()
	
	multiplayer.multiplayer_peer = peer
	is_host = true
	
#func join(oid):
	#extrernal_oid = oid
	#
#func handle_nat_connection(address, port):
	#var err = await connect_to_server(address, port)
	#
	#if(err != OK && !is_host):
		#print("NAT failed using relay")
		#
		#err = OK
		#
	#return err
	#
#func handle_relay_connection(address, port):
	#return await connect_to_server(address,port)
	#
##func connect_to_server(address, port):
	##var err = OK
	##
	##if !is_host:
		##var udp = PacketPeerUDP.new()
		##
		##udp.set_dest_address(address, port)
		##
		##err = await PacketHandshake.over_packet_peer(udp)
		##udp.close()
		##
		##if err != OK:
			##if err != ERR_BUSY:
				##print("Handshake failed")
				##return err
		##else:
			##print("Handshake success")
			##
		##var peer = ENetMultiplayerPeer.new()
		##err = peer.create_client(address, port, 0,0,0,Noray.local_port)
		##
		##if err != OK:
			##return err
			##
		##multiplayer.multiplayer_peer = peer
		##
		##return OK
	##else:
		##err = await PacketHandshake.over_enet(multiplayer.multiplayer_peer.host, address, port)
		##
	##return err
	#

		
	
	
	
	
