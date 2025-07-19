extends Node

# handles scenes and gameplay

var Players = {}

var currentScene = null


#var mainScene:Node
var client:Client = preload("res://Scenes/Client.tscn").instantiate()
var server:Server = preload("res://Scenes/Server.tscn").instantiate()

var LobbyInfo:Dictionary

# Called when the node enters the scene tree for the first time.
func changeScene(new:PackedScene):
	#mainScene.remove_child(currentScene)
	currentScene.queue_free()
	
	var newScene = new.instantiate()
	currentScene = newScene
	#mainScene.add_child(currentScene)
	
func _ready() -> void:
	add_child(client)
	add_child(server)
	
	#testing area:
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
