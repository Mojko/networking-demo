extends KinematicBody2D

var direction;
var old_position;
var new_position;
var time_inbetween = 0;
var biggest_time_inbetween = 0;

func _ready():
	RpcToClient.connect("set_object_position", self, "_on_server_set_object_position");
	RpcToClient.connect("move_object", self, "_on_server_move_object");

func _physics_process(delta):
	time_inbetween += delta;

	if(new_position != null):

		move_and_slide(direction * 150);
		
		if(global_transform.origin.distance_to(new_position) > 100):
			$network_interpoleration.interpolate_property(self, "position", global_transform.origin, new_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT);
			$network_interpoleration.start();
		
#		if(biggest_time_inbetween > 0.25 || global_transform.origin.distance_to(new_position) > 100):
#			$network_interpoleration.interpolate_property(self, "position", global_transform.origin, new_position, biggest_time_inbetween, Tween.TRANS_LINEAR, Tween.EASE_OUT);
#			$network_interpoleration.start();
#		if(biggest_time_inbetween > 0.25):
#			biggest_time_inbetween = 0;
	
func _on_server_set_object_position(object_id, position):
	if(get_parent().object_id != object_id):
		return;
		
	global_transform.origin = position;
	
func _on_server_move_object(object_id, direction, old_position, position):
	if(get_parent().object_id != object_id):
		return;
		
	self.direction = direction;
	self.old_position = old_position;
	self.new_position = position;
	if(time_inbetween > biggest_time_inbetween):
		biggest_time_inbetween = time_inbetween;
	time_inbetween = 0;