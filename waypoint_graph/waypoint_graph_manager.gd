tool
extends Panel

signal syncr()


var selected_waypoint
var selected_manager
var editor_plugin

func waypoint_data(waypoint):
	$ManagerData.hide()
	$WaypointData.show()
	selected_waypoint = waypoint
	$WaypointData/NodeName.text = waypoint.get_name()
	list_update()
	waypoint_type_list_update()

func register_editor_plugin(obj):
	editor_plugin = obj


func get_editor_plugin():
	return editor_plugin
		
func manager_data(manager):
	$ManagerData.show()
	$WaypointData.hide()
	selected_manager = manager
	type_list_update()

func type_list_update():
	var typedic = selected_manager.get_link_types()
	var type_list = $ManagerData/TypeList
	type_list.clear()
	
	for i in range(0, typedic.keys().size()):
		var val = typedic.keys()[i]
		type_list.add_item(val)
		
func waypoint_type_list_update():
	var typedic = selected_waypoint.get_parent().get_link_types()
	var type_list = $WaypointData/LinkList
	type_list.clear()
	for i in range(0, typedic.keys().size()):
		var val = typedic.keys()[i]
		type_list.add_item(val)
	
func list_update():
	var node_list = $WaypointData/NodeList;
	var links = selected_waypoint.get_links()
	node_list.clear()
	for i in range(0, links.size()):
		node_list.add_item(str(links[i]["id"]) + " : " + links[i]["link"])
	node_list.update()

func _on_Button_pressed():
	emit_signal("syncr")
	pass # replace with function body


func _on_Create1WL_pressed():
	var id = $WaypointData/LinkInput.get_text()
	var link = $WaypointData/LinkList.get_selected_items()[0]
	if id == "" || link == null:
		return
	var lt = $WaypointData/LinkList.get_item_text(link)
	selected_waypoint.add_1WL(int(id), lt)

	list_update()
	$WaypointData/NodeList.update()


func _on_Create2WL_pressed():
	var id = $WaypointData/LinkInput.get_text()
	var link = $WaypointData/LinkList.get_selected_items()[0]
	if id == "" || link == null:
		return
	var lt = $WaypointData/LinkList.get_item_text(link)
	selected_waypoint.add_2WL(int(id), lt)
	list_update()
	$WaypointData/NodeList.update()


func _on_DeleteL_pressed():
	var wp = $WaypointData/NodeList.get_item_text($WaypointData/NodeList.get_selected_items()[0])
	selected_waypoint.remove_L(int(wp))
	list_update()
	$WaypointData/NodeList.update()


func _on_DeleteType_pressed():
	
	pass # replace with function body


func _on_AddType_pressed():
	pass # replace with function body
