extends Node2D


@onready var oid_lbl = $VBoxContainer/OID
@onready var oid_input = $VBoxContainer/OIDInput

var peer = ENetMultiplayerPeer.new()
@export var player_scene:PackedScene 

func _ready() -> void:
	for i in GameManager.Players:
		print(i)
		_add_player(int(i))

func _add_player(id:int = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	
	call_deferred("add_child",player)
