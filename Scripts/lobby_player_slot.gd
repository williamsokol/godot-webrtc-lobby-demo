class_name LobbyPlayerSlot
extends PanelContainer

var player:Player
const playerSlot:PackedScene = preload("res://Scenes/LobbyPlayerSlot.tscn")

@export var playerName:OptionButton
@export var color:OptionButton
@export var ping:Label
@export var ms:MultiplayerSynchronizer

func _ready() -> void:
	set_multiplayer_authority(GameManager.LobbyInfo["currentLobby"].HostID)
	
	playerName.set_item_text(0,"dingerbell")
	if(player != null):
		SetPlayer(player)
		
func SetPlayer(p:Player):
	player = p
	playerName.selected = 0
	playerName.set_item_text(0,str(int(player.id)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func new_lobby_player_slot(p:Player = null):
	var ps = playerSlot.instantiate()
	ps.player = p

		
	return ps
