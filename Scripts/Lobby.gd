extends RefCounted
class_name Lobby

var HostID:int
var GameName:String = "no name rn"
var GameType:String 
var MapImg:Texture2D
var Players:Dictionary
var LobbyValue:String
var LobbyMax:int = 6
var Map:String = "Taiga"
var GameDetails:Dictionary

func _init(id:int = 0,lobbyValue = "") -> void:
	HostID = id
	LobbyValue = lobbyValue
	
func AddPlayer(id:int, name):
	Players[id] = {
		"name" : name,
		"id" : id,
		"index" : Players.size() + 1
	}
	return Players[id]
	
