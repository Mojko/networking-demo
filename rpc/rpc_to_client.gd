# Outgoing calls to clients

extends Node

signal update_connected_player_count(player_count, max_player_count)
signal start_game(connected_clients);
signal set_object_position(object_id, position);
signal move_object(object_id, direction, old_position, position)
signal client_disconnected(client);

remote func update_connected_player_count(player_count, max_player_count):
	PrintHelper.print_client("Updating connected player count");
	
	emit_signal("update_connected_player_count", player_count, max_player_count);
	
remote func start_game(connected_clients):
	PrintHelper.print_client("Game Starting");
	
	emit_signal("start_game", connected_clients);
	
remote func set_object_position(object_id, position):
	emit_signal("set_object_position", object_id, position);
	
remote func move_object(object_id, direction, old_position, position):
	emit_signal("move_object", object_id, direction, old_position, position);
	
remote func client_disconnected(client):
	emit_signal("client_disconnected", client);