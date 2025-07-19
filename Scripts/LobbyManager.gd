class_name LobbyManager
extends Control

var lobby:Lobby #From here on webrtc is use for lobby
var lobbySlots:Array[LobbyPlayerSlot] = []   
var players:Array[Player] = []  
var player:Player
var isHost:bool = false

@export var lobbySlot:PackedScene
@export var playerSlotContainer:VBoxContainer

func _ready() -> void:
	player = GameManager.client.player
	if(GameManager.LobbyInfo.has("currentLobby")):
		lobby = GameManager.LobbyInfo["currentLobby"]
		#AddPlayer.rpc(player)
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
		
	# I do not know why, but the first lobbyslot never works
	#var sacrifice = lobbySlot.instantiate()
	#playerSlotContainer.add_child(sacrifice)
	#sacrifice.queue_free()

	# get player infos and fill out lobby
	GetPlayerOrder()
func onLobbySlotSpawned(ps):
	lobbySlots.append(ps)
	
	# I should be in webrtc land by now
	pass # Replace with function body.
func GetPlayerOrder():
	#find the host
	
	RequestPlayerOrder.rpc_id(lobby.HostID,var_to_str(player) )
	pass
@rpc("any_peer","call_local")
func RequestPlayerOrder(ps:String):
	var p:Player = str_to_var(ps)
	var senderId:int = multiplayer.get_remote_sender_id()
	players.append(p)
	var senderSlot:int = players.size()-1
	p.lobbySlot = senderSlot
	#await get_tree().physics_frame # let the host setting affect the new authority
	print("this worked")
	print(players)
	ReturnPlayerOrder.rpc(var_to_str(players))
	pass

@rpc("any_peer","call_local")
func ReturnPlayerOrder(new_players_list:String):
	var npl:Array[Player] = str_to_var(new_players_list)
	for p in npl:
		print(p.lobbySlot)
		lobbySlots[p.lobbySlot].set_multiplayer_authority(p.id)
		lobbySlots[p.lobbySlot].SetPlayer(p)
	#lobbySlots[senderSlot].set_multiplayer_authority(senderId)
	#lobbySlots[senderSlot].SetPlayer(player)
	
@rpc("any_peer","call_local")
func AddPlayer(p:Player):
	
	# update lobby players
	lobby.AddPlayer(p.id,p.name)
	
	# Ask the host for the player order
	
	# place down players in that order 
	for i in lobby.Players:
		pass
	pass
	
