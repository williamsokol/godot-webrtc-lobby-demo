class_name LobbyPlayerSlot
extends PanelContainer

var Player:Dictionary
const playerSlot:PackedScene = preload("res://Scenes/LobbyPlayerSlot.tscn")

@export var playerName:OptionButton
@export var color:OptionButton
@export var ping:Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerName.set_item_text(0,"dingerbell")
	if(Player != {}):
		fillSlot(Player)
	pass # Replace with function body.
func fillSlot(p:Dictionary):
	Player = p
	playerName.selected = 0
	playerName.set_item_text(0,str(int(Player.id)))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func new_lobby_player_slot(player = {}):
	var ps = playerSlot.instantiate()
	ps.Player = player

		
	return ps
