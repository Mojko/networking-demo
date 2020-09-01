extends Node

export(PackedScene) var world;

onready var lobby_ui = get_node("lobby_ui");

func _ready():
	assert(lobby_ui);
	assert(world);
	
	lobby_ui.hide();
	
	get_tree().connect("connected_to_server", self, "_on_connected_to_server");
	RpcToClient.connect("update_connected_player_count", self, "_on_update_connected_player_count");
	RpcToClient.connect("start_game", self, "_on_start_game");
	
func _on_connected_to_server():
	PrintHelper.print_client("Connected to server");
	lobby_ui.show();
	
func _on_update_connected_player_count(player_count, max_player_count):
	lobby_ui.update_player_count(player_count, max_player_count);
	
func _on_start_game(connected_clients):
	var world_instance = world.instance();
	get_parent().add_child(world_instance);
	world_instance.start_game(connected_clients);
	
	lobby_ui.queue_free();
