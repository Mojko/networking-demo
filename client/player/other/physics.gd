extends KinematicBody2D

func _ready():
	RpcToClient.connect("set_object_position", self, "_on_server_set_object_position");

func _on_server_set_object_position(object_id, position):
	if(get_parent().object_id != object_id):
		return;
		
	global_transform.origin = position;