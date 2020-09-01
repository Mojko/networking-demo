extends Control

onready var rpc_calls = get_node("vbox_container/rpc_calls");

func _ready():
	assert(rpc_calls);