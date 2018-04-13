tool
extends Node2D

var font = DynamicFont.new()
var font_data = DynamicFontData.new()
var mylabel = Label.new()
var nodes = []
var tmp_nodes_data = {}
var link_types
var link_tn
onready var link_types_gd = load("res://addons/waypoint_graph/links_types.gd")





func _process(delta):
	update()


func _ready():
	link_tn = link_types_gd.new()
	link_types = link_tn.get_links_types()



func get_link_types():
	return link_types
	
func get_waypoint(id):
	return get_node(str(id))

	
func is_class(cl):
	return cl == "PathManager"
	
func get_class():
	return "PathManager"

func register_node(obj):
	if obj.is_class("Waypoint"):
		obj.set_name(str(get_child_count() - 1))
		return str(get_child_count() - 1)

func update_links():
	tmp_nodes_data = {}
	for i in range(0, get_child_count()):
		var data = {}
		var node = get_child(i)
		data["pos"] = node.get_global_position()
		data["links"] = node.get_links()
		tmp_nodes_data[node.id] = data

func dijsktra(initial, maxcost = -1):
	var links = {}
	var nodes = {}
	for i in range(0, get_child_count()):
		var node = get_child(i)
		links[node.id] = node.get_links()
		nodes[node.id] = 0
	var visited = {initial: 0}
	var path = {}

	while nodes: 
		var min_node = null
		for node in nodes:
			if visited.has(int(node)):
				if min_node == null:
					min_node = node
				elif visited[int(node)] < visited[int(min_node)]:
					min_node = node
		if min_node == null:
			break

		nodes.erase(min_node)
		var current_weight = visited[int(min_node)]
	
		for edge in links[min_node]:
			var lm = links[min_node]
			var weight
			var edge_weight = link_types[edge["link"]]["weight"]
			if edge_weight == -1:
				weight = current_weight + distance(int(min_node), int(edge["id"]))
			else:
				#Here is the compute of custom weights
				weight = current_weight + distance(int(min_node), int(edge["id"])) * edge_weight

			if weight > maxcost && maxcost > 0:
				continue
			if !visited.has(edge["id"]) || weight < visited[edge["id"]]:
				visited[edge["id"]] = weight
				path[edge["id"]] = { "to" : min_node, "linktype" : edge["link"] }


	return {"paths" : path, "weights": visited }

func distance(from, to):
	var node_from = get_child(from)
	var node_to = get_child(to)
	return node_from.global_position.distance_to(node_to.global_position)


func get_real_path(from, to, paths = null):
	if paths == null:
		paths = dijsktra(from)["paths"]

	var current_node = to
	var real_path = []
	real_path.append(to)
	while (str(current_node) != str(from)):
		var new_node = paths[int(current_node)]["to"];
		real_path.push_front(new_node)
		current_node = new_node
	return real_path


func get_possibilities(from, maxweight):
	var djk = dijsktra(from, maxweight)
	var weights = djk["weights"]
	
	var paths = {}
	for i in weights.keys():
		if i == from:
			continue
		var real_path = get_real_path(from, i, djk["paths"])
		paths[i] = real_path
	return paths
	

func _draw():

	if !Engine.is_editor_hint():
		return
	update_links()
	
	if (link_types == null):
		return
	font_data.font_path = "res://addons/waypoint_graph/osdmono.ttf"
	font.font_data = font_data
	font.set_use_filter(false)
	font.size = 8

	for i in tmp_nodes_data:

		var cn = tmp_nodes_data[i];

		for y in range (0, cn["links"].size()):
			var tn = cn["links"][y];
			var end_pos = tmp_nodes_data[str(tn["id"])]["pos"]
			var start_pos = cn["pos"]

			
			var dc = (end_pos - start_pos).normalized() * 8
			draw_line(start_pos + dc, end_pos - dc, Color("#ffffff"), 1, true);
			#draw_circle(start_pos + dc, 2, Color("#ffffff"))

			draw_circle(end_pos - dc, 2, link_types[tn["link"]]["color"])
		draw_string(font, cn["pos"] + Vector2(10,10), str(i), Color("#ffffff"));

	pass
