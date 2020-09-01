extends Control

onready var connection_timeout = get_node("connection_timeout");

func _ready():
	assert(connection_timeout);

func show():
	.show();
	$connection_timeout.start();