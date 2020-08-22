extends Node

onready var game = get_node("host/game");
onready var rpc_client_connector = get_node("rpc_client_connector");
onready var host = get_node("host");
onready var gameobject_manager = get_node("gameobject_manager");

# Put this in json later
const DEFAULT_PORT = 31400;
const MAX_PLAYERS = 4;

var is_host : bool = true;
var in_lobby : bool;

var connected_clients = [];

func _connect_signals():
	get_tree().connect("network_peer_connected", self, "_on_client_connect");
	get_tree().connect("network_peer_disconnected", self, "_on_client_disconnect");

func _create_server(port, max_connections):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS);
	get_tree().set_network_peer(peer);
	PrintHelper.print_server("Server created");
	
func _connect_server_as_host():
	var object_id = gameobject_manager.create_game_object(Vector2(randi() % 200, randi() % 200));
	
	connected_clients.append({
		"id": 1,
		"object_id": object_id
	});
	
	RpcToClient.update_connected_player_count(connected_clients.size(), MAX_PLAYERS);
	game._on_connected_to_server();
	
func _ready():
	assert(game);
	assert(rpc_client_connector);
	assert(host);
	assert(gameobject_manager);
	
	_connect_signals();
	_create_server(DEFAULT_PORT, MAX_PLAYERS);
	
	rpc_client_connector.connect_rpc_signals(RpcToClient, game);
	
	if(is_host):
		_connect_server_as_host();
	else:
		host.queue_free();
		
	RpcToServer.connect("gameobject_move", self, "_on_client_gameobject_move");
	
func update_connected_player_count():
	RpcToClient.rpc("update_connected_player_count", connected_clients.size(), MAX_PLAYERS);
	if(is_host):
		RpcToClient.update_connected_player_count(connected_clients.size(), MAX_PLAYERS);
		
func set_object_position(object_id, position):
	RpcToClient.rpc("set_object_position", object_id, position);
	if(is_host):
		RpcToClient.set_object_position(object_id, position);
		
func start_game():
	RpcToClient.rpc("start_game", connected_clients);
	if(is_host):
		RpcToClient.start_game(connected_clients);
	
	for object in gameobject_manager.gameobjects:
		set_object_position(object.id, object.position);
		
func client_disconnected(client):
	RpcToClient.rpc("client_disconnected", client);
	if(is_host):
		RpcToClient.client_disconnected(client);
	
func _on_client_connect(id):
	PrintHelper.print_server("Client with id(" + str(id) + ") connected to the server");
	
	var object_id = gameobject_manager.create_game_object(Vector2(randi() % 200, randi() % 200));
	
	connected_clients.append({
		"id": id,
		"object_id": object_id
	});
	
	update_connected_player_count();
		
func _on_client_disconnect(id):
	PrintHelper.print_server("Client with id(" + str(id) + ") disconnected from the server");
	
	var to_remove = 0;
	for client in connected_clients:
		if(client.id == id):
			break;
		to_remove += 1;
	
	var client_to_disconnect = connected_clients[to_remove];
	connected_clients.remove(to_remove);
	
	if(in_lobby):
		update_connected_player_count();
	else:
		client_disconnected(client_to_disconnect);
	
func _on_client_gameobject_move(object_id, old_position, new_position):
	gameobject_manager.set_gameobject_position(object_id, new_position);
	set_object_position(object_id, new_position);