extends KinematicBody2D

var old_position;
var new_position;
var time_inbetween = 0;

func _ready():
	RpcToClient.connect("set_object_position", self, "_on_server_set_object_position");
	RpcToClient.connect("move_object", self, "_on_server_move_object");

func _physics_process(delta):
	
	time_inbetween += delta;
	
	if(new_position != null):
		
		var t = Transform2D(global_transform);
#		t.origin = old_position;

		var t2 = Transform2D(global_transform);
		t2.origin = new_position;

		var t3 = t2.interpolate_with(t, delta * time_inbetween);
		global_transform = t3;
	
func _on_server_set_object_position(object_id, position):
	if(get_parent().object_id != object_id):
		return;
		
	global_transform.origin = position;
	
func _on_server_move_object(object_id, old_position, position):
	if(get_parent().object_id != object_id):
		return;
		
	self.old_position = old_position;
	self.new_position = position;
	time_inbetween = 0;