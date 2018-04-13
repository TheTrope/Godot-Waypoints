tool
extends Node2D


export var exlinks = []
export var id = -1
var links = []
func _ready():
	for i in range(0, exlinks.size()):
		links.append(exlinks[i])
	

	if !get_parent().is_class("PathManager"):
		queue_free()
	if get_name() == "Waypoint":
		id = get_parent().register_node(self)
	if !Engine.is_editor_hint():
		hide()
		pass
	
	var tex = preload("res://addons/waypoint_graph/targetx128.png")
	set_texture(tex)
	set_scale(Vector2(0.1,0.1))
	
		
func _process(delta):
	update()

func add_2WL(waypoint_to, link_type):
	add_1WL(waypoint_to, link_type)
	get_parent().get_waypoint(waypoint_to).add_1WL(id, link_type)
	
func add_1WL(waypoint_to, link_type):
	print("add 1wl " + get_name())
	var dic = {}
	dic["id"] = int(waypoint_to)
	dic["link"] = link_type
	links.append(dic)
	exlinks = links

func remove_L(waypoint):
	for i in range (0, links.size()):
		if links[i]["id"] == waypoint:
			links.remove(i)

func get_links():
	return links

func is_class(cl):
	return cl == "Waypoint"
	
func get_class():
	return "Waypoint"
	
func _draw():
	pass