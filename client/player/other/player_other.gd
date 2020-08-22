extends NetworkedObject

onready var name_label = get_node("physics/name");

func _ready():
	assert(name_label);