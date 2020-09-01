extends Node

func _ready():
	RpcToServer.connect("gameobject_move", self, "_on_client_gameobject_move");

func _on_client_gameobject_move(object_id, direction, old_position, new_position):
	##TODO: Check for invalid move
	get_parent().gameobject_manager.set_gameobject_position(object_id, new_position);
	get_parent().rpc_sender.move_object(object_id, direction, old_position, new_position);