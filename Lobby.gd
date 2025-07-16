extends RefCounted
class_name Lobby

var HostID:int
var Players:Dictionary
var LobbyMax:int = 10

func _init(id) -> void:
	HostID = id
	
func AddPlayer(id:int, name):
	Players[id] = {
		"name" : name,
		"id" : id,
		"index" : Players.size() + 1
	}
	return Players[id]
