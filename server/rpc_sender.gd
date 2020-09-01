extends Node

func update_connected_player_count():
	RpcToClient.rpc("update_connected_player_count", get_parent().connected_clients.size(), get_parent().MAX_PLAYERS);
	if(get_parent().is_host):
		RpcToClient.update_connected_player_count(get_parent().connected_clients.size(), get_parent().MAX_PLAYERS);
		
func set_object_position(object_id, position):
	RpcToClient.rpc("set_object_position", object_id, position);
	if(get_parent().is_host):
		RpcToClient.set_object_position(object_id, position);
		
func move_object(object_id, direction, old_position, position):
	RpcToClient.rpc_unreliable("move_object", object_id, direction, old_position, position);
	if(get_parent().is_host):
		RpcToClient.move_object(object_id, direction, old_position, position);
		
func start_game():
	for client in get_parent().connected_clients:
		var object_id = get_parent().gameobject_manager.create_game_object(Vector2(200 + randi() % 400, 200 + randi() % 300));
		client.object_id = object_id;
	
	RpcToClient.rpc("start_game", get_parent().connected_clients);
	if(get_parent().is_host):
		RpcToClient.start_game(get_parent().connected_clients);
	
	for object in get_parent().gameobject_manager.gameobjects:
		set_object_position(object.id, object.position);
		
func client_disconnected(client):
	RpcToClient.rpc("client_disconnected", client);
	if(get_parent().is_host):
		RpcToClient.client_disconnected(client);