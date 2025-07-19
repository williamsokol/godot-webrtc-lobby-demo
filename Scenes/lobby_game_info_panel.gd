class_name LobbyGameInfoPanel
extends PanelContainer

var _displayedLobby:Lobby


@export var HostID:int
@export var MapImg:TextureRect
@export var GameName:Label
@export var GameType:Label
@export var GameDetails:VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.
func SetDisplayedLobby(lobby:Lobby):
	GameName.text = lobby.GameName
	MapImg.texture = lobby.MapImg
	GameType.text = lobby.GameType
	GameDetails
	_displayedLobby = lobby
	for i in lobby.GameDetails:
		print(i)
	pass
