extends Control

onready var player_count_label = get_node("player_count_label");

func _ready():
	assert(player_count_label);
	
func update_player_count(player_count, max_player_count):
	player_count_label.update_player_count(player_count, max_player_count);