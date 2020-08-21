extends Node2D

onready var name_label = get_node("body/name");

var id;

func _ready():
	assert(name_label);
	
func set_id(id):
	self.id = id;
	name_label.text = str(id);