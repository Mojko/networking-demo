extends Node2D

onready var name_label = get_node("name");

func set_id(id):
	name_label.text = str(id);