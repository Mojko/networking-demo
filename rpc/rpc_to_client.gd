# Outgoing calls to clients


extends Node

signal connected_player_count(player_count)

remote func connected_player_count(player_count):
	emit_signal("connected_player_count", player_count);