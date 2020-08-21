# Outgoing calls to clients


extends Node

signal update_connected_player_count(player_count, max_player_count)
signal start_game(connected_clients);

remote func update_connected_player_count(player_count, max_player_count):
	PrintHelper.print_client("Updating connected player count");
	
	emit_signal("update_connected_player_count", player_count, max_player_count);
	
remote func start_game(connected_clients):
	PrintHelper.print_client("Game Starting");
	
	emit_signal("start_game", connected_clients);