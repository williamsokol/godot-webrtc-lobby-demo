extends RefCounted
class_name Lobby

var HostID:int
var Map:String = "Taiga"
var MapImg:Image
var GameName:String = "no name rn"
var Players:Dictionary
var LobbyValue:String
var LobbyMax:int = 6

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
	
func to_dict():
	return var_to_str(self)
	return {
		"HostID": HostID,
		"Map" : Map,
		"GameName" : GameName,
		"Players": Players,
		"LobbyValue" : LobbyValue,
		"LobbyMax": LobbyMax
		
	}

static func from_dict(data: Dictionary) -> Lobby:
	var lobby = Lobby.new(data["HostID"],data.LobbyValue)
	lobby.Map = data["Map"]
	lobby.GameName = data["GameName"]
	lobby.Players = data["Players"]
	lobby.LobbyValue = data["LobbyValue"]
	lobby.LobbyMax = data["LobbyMax"]
	return lobby
