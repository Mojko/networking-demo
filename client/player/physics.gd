extends KinematicBody2D

signal move(object_id, old_position, new_position);

var speed = 50;
var old_position;

func _ready():
	connect("move", RpcToServer, "_on_gameobject_move");
	RpcToClient.connect("set_object_position", self, "_on_server_set_object_position");
	old_position = global_transform.origin;

var v = 0;

func _physics_process(delta):
	var direction = Vector2();
	
	v += 0.1;
	direction.x += cos(v);
	direction.y += sin(v);
	
	if(Input.is_action_pressed("up")):
		direction.y -= 2;
	if(Input.is_action_pressed("right")):
		direction.x += 2;
	if(Input.is_action_pressed("down")):
		direction.y += 2;
	if(Input.is_action_pressed("left")):
		direction.x -= 2;
		
	move_and_slide(direction.normalized() * speed);
	
	if(direction.length() > 0):
		emit_signal("move", get_parent().object_id, old_position, global_transform.origin);
	
func _on_server_set_object_position(object_id, position):
	if(get_parent().object_id != object_id):
		return;

	var t = Transform2D(global_transform);
	t.origin = position;
	var t2 = global_transform.interpolate_with(t, 0.2);
	global_transform.origin = t2.origin;