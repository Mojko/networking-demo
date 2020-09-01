extends Node2D

export(PackedScene) var player_prefab;
export(PackedScene) var other_player_prefab;

func _ready():
	RpcToClient.connect("client_disconnected", self, "_on_client_disconnect");

func start_game(connected_clients):
	print("Players joined in the game: [", connected_clients, "]");
	
	for client in connected_clients:
		if(client.id == get_tree().get_network_unique_id()):
			var instance = player_prefab.instance();
			add_child(instance);
			instance.object_id = client.object_id;
			instance.name = str(client.id);
			instance.name_label.text = str(client.id);
		else:
			var instance = other_player_prefab.instance();
			add_child(instance);
			instance.object_id = client.object_id;
			instance.name = str(client.id);
			instance.name_label.text = str(client.id);
			
func _on_client_disconnect(client):
	var child_to_remove = null;
	for child in get_children():
		if(!(child is NetworkedObject)):
			continue;
		if(child.object_id == client.object_id):
			child_to_remove = child;
	child_to_remove.queue_free();