extends Node

func connect_rpc_signals(rpc_client, target):
	rpc_client.connect("update_connected_player_count", target, "_on_update_connected_player_count");
	rpc_client.connect("start_game", target, "_on_start_game");