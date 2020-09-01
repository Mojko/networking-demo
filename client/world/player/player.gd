extends NetworkedObject

onready var name_label = get_node("body/name");

func _ready():
	assert(name_label);