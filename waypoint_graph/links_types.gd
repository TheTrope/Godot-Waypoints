extends Node

var links_types
func _init():
	links_types = {}
	links_types["run"] = new_linktype(-1, Color("#ffffff"))
	links_types["jump"] = new_linktype(1, Color("#ffc700"))
	links_types["climb"] = new_linktype(1, Color("#ed4010"))

func get_links_types():
	return links_types


func new_linktype(weight, color):
	var dic = {}
	dic["weight"] = weight
	dic["color"] = color
	return dic