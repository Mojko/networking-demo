extends KinematicBody2D

signal move(object_id, old_position, new_position);

var speed = 50;

func _ready():
	connect("move", RpcToServer, "gameobject_move");

func _process(delta):
	var direction = Vector2();
	
	if(Input.is_action_pressed("up")):
		direction.y -= 1;
	if(Input.is_action_pressed("right")):
		direction.x += 1;
	if(Input.is_action_pressed("down")):
		direction.y += 1;
	if(Input.is_action_pressed("left")):
		direction.x -= 1;
		
	var old_position = global_transform.origin;
	move_and_slide(direction.normalized() * speed);