extends PanelContainer

var client:Client
var server:Server

@export var lineEdit:LineEdit

func _ready() -> void:	
	await GameManager.is_node_ready()
	client = GameManager.client
	server = GameManager.server

func _on_start_client_button_down() -> void:
	client._on_start_client_button_down()
	
func _on_start_server_button_down() -> void:
	server._on_start_server_button_down()
	
func _on_start_game_button_down() -> void:
	client._on_button_button_down()
	
func _on_join_lobby_button_down() -> void:
	client._on_join_lobby_button_down(lineEdit.text)
	
func _on_get_lobby_button_down() -> void:
	client._on_get_lobby_button_down()
