tool
extends EditorPlugin

signal fill_list()

var dock
var l1w_button
var selected;
var mp

export var links_types = {}
func _enter_tree():

	init()


func init():

	set_process_input(true)
	add_custom_type("Waypoint", "Sprite", preload("waypoint.gd"), preload("res://addons/waypoint_graph/targetx16.png"))
	add_custom_type("PathManager", "Node2D", preload("path_manager.gd"), preload("res://addons/waypoint_graph/networkx16.png"))
	dock = load("res://addons/waypoint_graph/node_path_dock.tscn").instance()
	dock.register_editor_plugin(self)
	add_control_to_dock(DOCK_SLOT_LEFT_BL, dock)
	dock.connect("syncr", self, "_syncr")

	#add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, l1w_button)

	
func get_link_types():
	return links_types

#func _input(ev):
	#if ev is InputEventMouseMotion:
		#mp = get_tree().get_edited_scene_root().get_viewport().get_mouse_position()
	#if ev is InputEventKey:
		##print(ev.scancode)
	

	
func forward_intput_event(event):
	print(event)

func edit(object):
	selected = object
	if object.is_class("Waypoint"):
		dock.waypoint_data(object)
	if object.is_class("PathManager"):
		dock.manager_data(object)
	dock.show()
	
func handles(obj):
	selected = null
	if obj.is_class("Waypoint") || obj.is_class("PathManager"):
		return true
	if dock != null:
		dock.hide()
	return false
	
func close():
	remove_custom_type("Waypoint")
	remove_custom_type("PathManager")

	set_process_input(false)
	remove_control_from_docks(dock)
	if dock != null:
		dock.queue_free()

func _exit_tree():
	close()

func _syncr():
	close()
	init()
