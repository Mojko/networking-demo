extends Node

onready var game = get_node("host/game");
onready var rpc_client_connector = get_node("rpc_client_connector");
onready var host = get_node("host");
onready var gameobject_manager = get_node("gameobject_manager");

# Put this in json later
const DEFAULT_PORT = 31400;
const MAX_PLAYERS = 4;

var is_host : bool = true;

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
	
func update_connected_player_count():
	RpcToClient.rpc("update_connected_player_count", connected_clients.size(), MAX_PLAYERS);
	if(is_host):
		RpcToClient.update_connected_player_count(connected_clients.size(), MAX_PLAYERS);
		
func start_game():
	RpcToClient.rpc("start_game", connected_clients);
	if(is_host):
		RpcToClient.start_game(connected_clients);
	
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
		
	connected_clients.remove(to_remove);
	update_connected_player_count();