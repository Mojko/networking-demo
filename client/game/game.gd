extends Node

onready var lobby_ui = get_node("lobby_ui");
onready var connecting = get_node("connecting");
onready var world = get_node("world");

func _ready():
	assert(lobby_ui);
	assert(connecting);
	assert(world);
	lobby_ui.hide();
	
	RpcToClient.connect("update_connected_player_count", self, "_on_update_connected_player_count");
	RpcToClient.connect("start_game", self, "_on_start_game");
	
func _on_update_connected_player_count(player_count, max_player_count):
	lobby_ui.update_player_count(player_count, max_player_count);

func _on_connected_to_server():
	PrintHelper.print_client("Connected to server");
	connecting.queue_free();
	lobby_ui.show();
	
func _on_start_game(connected_clients):
	world.start_game(connected_clients);
	lobby_ui.queue_free();