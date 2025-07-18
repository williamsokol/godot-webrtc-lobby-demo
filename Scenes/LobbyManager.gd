extends Control

var lobby:Lobby #From here on webrtc is use for lobby 
var player:Player

@export var playerSlotContainer:VBoxContainer

func _ready() -> void:
	player = GameManager.client.player
	if(GameManager.LobbyInfo.has("currentLobby")):
		lobby = GameManager.LobbyInfo["currentLobby"]
		lobby.AddPlayer(player.id,player.name)
	else:
		lobby = Lobby.new(123,"Testing")
	# get player infos and fill out lobby
	for slot in range(lobby.LobbyMax):
		
		var player = {}
		if(lobby.Players.keys().size()>slot):
			print("yeeee")
			player = lobby.Players[lobby.Players.keys()[slot]]
			print(player.id)
		var ps = LobbyPlayerSlot.new_lobby_player_slot(player)
		playerSlotContainer.add_child(ps)
		
	
	# I should be in webrtc land by now
	pass # Replace with function body.
