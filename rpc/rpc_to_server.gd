# Incoming calls to server from clients

extends Node

signal gameobject_move(id, old_position, new_position);

remote func gameobject_move(id, old_position, new_position):
	emit_signal("gameobject_move", id, old_position, new_position);