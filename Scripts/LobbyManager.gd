class_name LobbyManager
extends Control

var lobby:Lobby #From here on webrtc is use for lobby
var lobbySlots:Array[LobbyPlayerSlot] = []
var players:Array[Player] = []
var player:Player
var isHost:bool = false

@export var lobbySlot:PackedScene
@export var playerSlotContainer:VBoxContainer

var last_ping_time

func _ready() -> void:
	player = GameManager.client.player
	if(GameManager.LobbyInfo.has("currentLobby")):
		lobby = GameManager.LobbyInfo["currentLobby"]
	else:
		lobby = Lobby.new(123,"Testing")
		
	$MultiplayerSpawner.spawned.connect(onLobbySlotSpawned)
	$MultiplayerSpawner.set_multiplayer_authority(lobby.HostID)
	if(lobby.HostID == player.id):
		isHost = true
		for slot in range(lobby.LobbyMax):
			var ps = lobbySlot.instantiate()
			playerSlotContainer.add_child(ps,true)
			lobbySlots.append(ps)
	else:
		await multiplayer.peer_connected
	# get player infos and fill out lobby
	GetPlayerOrder()
	
func onLobbySlotSpawned(ps):
	lobbySlots.append(ps)
	
func GetPlayerOrder():
	#find the host
	RequestPlayerOrder.rpc_id(lobby.HostID,var_to_str(player) )
	
@rpc("any_peer","call_local")
func RequestPlayerOrder(ps:String):
	var p:Player = str_to_var(ps)
	var senderId:int = multiplayer.get_remote_sender_id()
	players.append(p)
	var senderSlot:int = players.size()-1
	p.lobbyIndex = senderSlot
	#await get_tree().physics_frame # let the host setting affect the new authority
	print("this worked")
	print(players)
	ReturnPlayerOrder.rpc(var_to_str(players))
	pass

@rpc("any_peer","call_local")
func ReturnPlayerOrder(new_players_list:String):
	var npl:Array[Player] = str_to_var(new_players_list)
	for p in npl:
		lobbySlots[p.lobbyIndex].set_multiplayer_authority(p.id)
		lobbySlots[p.lobbyIndex].SetPlayer(p)
		if (p.id == player.id):
			player.lobbyIndex = p.lobbyIndex
	ping()
	#lobbySlots[senderSlot].set_multiplayer_authority(senderId)
	#lobbySlots[senderSlot].SetPlayer(player)
	
@rpc("any_peer","call_local")
func AddPlayer(p:Player):
	lobby.AddPlayer(p.id,p.name)


@rpc("any_peer","call_local")
func ping(iam_asking: bool = true) -> void:
	if iam_asking:
		last_ping_time = Time.get_unix_time_from_system()
		ping.rpc(false)
	else:
		var senderId: int = multiplayer.get_remote_sender_id()
		print_ping.rpc_id(senderId,player.lobbyIndex)

@rpc("any_peer","call_local")
func print_ping(pli):
	var pingDelay:int = Time.get_unix_time_from_system() - last_ping_time
	lobbySlots[pli].ping.text = "Ping: " + str(pingDelay)
	multiplayer.get_remote_sender_id()
	print( "Ping delay: " + str(pli ) )
	
	
func _on_start_game_button_down() -> void:
	#ping()
	GameManager.client._on_button_button_down()
	pass # Replace with function body.


func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/lobby_browser.tscn")
	
	# if lobby host close lobby
	
	# 
	pass # Replace with function body.
