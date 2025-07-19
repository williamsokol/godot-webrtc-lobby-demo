extends Control

@onready var client:Client = GameManager.client
@export var lobbyContainer:VBoxContainer
@export var searchBar:LineEdit
@export var gameInfoPanel:LobbyGameInfoPanel
var selectedLobby:Lobby

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await GameManager.is_node_ready()
	
	client.lobbyUpdate.connect(UpdateLobbies)
	
	await client.connectedToWSServer
	client._on_get_lobby_button_down()
	pass # Replace with function body.

func UpdateLobbies(lobbies):
	ClearLobbies()
	for i in lobbies:
		print(lobbies[i].GameName)
		var lobbyBtn = LobbyButton.new_lobby_button(lobbies[i])
		lobbyContainer.add_child(lobbyBtn)
		lobbyBtn.lobbySelected.connect(SelectLobby)
		
func SelectLobby(lobby:Lobby):
	selectedLobby = lobby
	searchBar.text = str(lobby.GameName)
	gameInfoPanel.SetDisplayedLobby(lobby)
	pass

func ClearLobbies():
	for i in lobbyContainer.get_children():
		i.queue_free()
	pass

func _on_join_lobby_button_down() -> void:
	if(selectedLobby == null):
		print("no lobby selected!!!")
		return
	# enter lobby scene
	GameManager.LobbyInfo["currentLobby"] = selectedLobby
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
	# enter lobby in server
	client.join_lobby(selectedLobby.LobbyValue)
	pass # Replace with function body.


func _on_refresh_button_down() -> void:
	client._on_get_lobby_button_down()


func _on_create_lobby_button_down() -> void:
	
	client.join_lobby("")
	await client.recivedLobbyValue
	client._on_get_lobby_button_down()
	await client.lobbyUpdate
	GameManager.LobbyInfo["currentLobby"] = client.lobbies[client.lobbyValue]
	get_tree().change_scene_to_file("res://Scenes/lobby.tscn")
