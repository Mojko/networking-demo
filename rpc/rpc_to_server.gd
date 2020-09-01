# Incoming calls to server from clients

extends Node

signal gameobject_move(object_id, direction, old_position, new_position);

remote func gameobject_move(object_id, direction, old_position, new_position):
	emit_signal("gameobject_move", object_id, direction, old_position, new_position);
	get_tree().get_root().get_node("main").debug.rpc_calls.increment();
	
#Client func
func _on_gameobject_move(object_id, direction, old_position, new_position):
	if(!NetworkGlobals.is_server):
		rpc_unreliable_id(1, "gameobject_move", object_id, direction, old_position, new_position);
	else:
		gameobject_move(object_id, direction, old_position, new_position);