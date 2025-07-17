extends Control

@onready var client:Client = $Client
@export var lobbyContainer:VBoxContainer
@export var searchBar:LineEdit
var selectedLobby:Lobby

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	client.lobbyUpdate.connect(UpdateLobbies)
	
	print("starting lobby task ")
	await client.connectedToWSServer
	client._on_get_lobby_button_down()
	print("lobbyloby")
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
	pass

func ClearLobbies():
	for i in lobbyContainer.get_children():
		i.queue_free()
	pass

func _on_join_lobby_button_down() -> void:
	client.join_lobby(selectedLobby.LobbyValue)
	pass # Replace with function body.
