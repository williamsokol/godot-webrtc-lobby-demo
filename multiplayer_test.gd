extends Node2D


@onready var oid_lbl = $VBoxContainer/OID
@onready var oid_input = $VBoxContainer/OIDInput

var peer = ENetMultiplayerPeer.new()
@export var player_scene:PackedScene 

func _ready() -> void:
	await Multiplayer.noray_connected
	oid_lbl.text = Noray.oid

func _on_host_pressed() -> void:
	Multiplayer.host()
	#peer.create_server(135)
	#multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child",player)


func _on_join_pressed() -> void:
	Multiplayer.join(oid_input.text)
	pass
	#peer.create_client("localhost", 135)
	#multiplayer.multiplayer_peer = peer
	


func _on_copy_oid_pressed() -> void:
	DisplayServer.clipboard_set(Noray.oid)
