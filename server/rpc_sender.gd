extends Node

func update_connected_player_count():
	RpcToClient.rpc("update_connected_player_count", get_parent().connected_clients.size(), get_parent().MAX_PLAYERS);
	if(get_parent().is_host):
		RpcToClient.update_connected_player_count(get_parent().connected_clients.size(), get_parent().MAX_PLAYERS);
		
func set_object_position(object_id, position):
	RpcToClient.rpc_unreliable("set_object_position", object_id, position);
	if(get_parent().is_host):
		RpcToClient.set_object_position(object_id, position);
		
func start_game():
	RpcToClient.rpc("start_game", get_parent().connected_clients);
	if(get_parent().is_host):
		RpcToClient.start_game(get_parent().connected_clients);
	
	for client in get_parent().connected_clients:
		var object_id = get_parent().gameobject_manager.create_game_object(get_parent().player_spawn_manager.get_next_available_spawn_position());
		client.object_id = object_id;
	
	for object in get_parent().gameobject_manager.gameobjects:
		set_object_position(object.id, object.position);
		
func client_disconnected(client):
	RpcToClient.rpc("client_disconnected", client);
	if(get_parent().is_host):
		RpcToClient.client_disconnected(client);