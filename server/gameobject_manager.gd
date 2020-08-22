extends Node

var gameobjects = [];
var next_available_object_id = 1000;

func create_game_object(position):
	gameobjects.append(
	{
		"id": next_available_object_id,
		"position": position
	});
	
	var object_id = next_available_object_id;
	
	next_available_object_id += 1;
	
	return object_id;
	
func set_gameobject_position(id, position):
	for go in gameobjects:
		if(go.id == id):
			go.position = position;
	
func get_gameobject_position(id):
	for go in gameobjects:
		if(go.id == id):
			return go.position;