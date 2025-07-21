class_name LobbyButton
extends PanelContainer

const my_scene:PackedScene = preload("res://Scenes/LobbyButton.tscn")

signal lobbySelected

@export var gameName:Label
@export var map:Label
@export var players:Label
const PlayerMax = 8
@export var host:Label

var lobby:Lobby

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func new_lobby_button(lobby: Lobby):
	var new_lobby_button:LobbyButton = my_scene.instantiate()
	new_lobby_button.gameName.text = lobby.GameName
	new_lobby_button.map.text = lobby.Map
	new_lobby_button.players.text = str(lobby.Players.size()) +"/"+str(lobby.LobbyMax)
	new_lobby_button.host.text = str(lobby.HostID)
	new_lobby_button.lobby = lobby
	
	return new_lobby_button


func _on_button_button_down() -> void:
	lobbySelected.emit(lobby)
	pass # Replace with function body.
