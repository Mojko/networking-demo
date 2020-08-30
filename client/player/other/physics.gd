extends KinematicBody2D

func _ready():
	RpcToClient.connect("set_object_position", self, "_on_server_set_object_position");

func _on_server_set_object_position(object_id, position):
	if(get_parent().object_id != object_id):
		return;
		
	var t = Transform2D(global_transform);
	t.origin = position;
	var t2 = global_transform.interpolate_with(t, 0.2);
	global_transform.origin = t2.origin;