extends Node2D

signal gameobject_move(id, old_position, new_position);

export(PackedScene) var player_prefab;
export(PackedScene) var other_player_prefab;

func start_game(connected_clients):
	print("Players joined in the game: [", connected_clients, "]");
	
	for client in connected_clients:
		if(client.id == get_tree().get_network_unique_id()):
			var instance = player_prefab.instance();
			add_child(instance);
			instance.global_transform.origin = client.position;
			instance.call_deferred("set_id", client.id);
			instance.name = str(client.id);
		else:
			var instance = other_player_prefab.instance();
			add_child(instance);
			instance.global_transform.origin = client.position;
			instance.call_deferred("set_id", client.id);
			instance.name = str(client.id);