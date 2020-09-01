extends Node

onready var lobby = get_node("host/lobby");
onready var host = get_node("host");
onready var gameobject_manager = get_node("gameobject_manager");
onready var player_spawn_manager = get_node("player_spawn_manager");
onready var rpc_sender = get_node("rpc_sender");

# Put this in json later
const DEFAULT_PORT = 31400;
const MAX_PLAYERS = 1000;

var is_host : bool = true;
var in_lobby : bool = true;

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
	connected_clients.append({
		"id": 1,
		"object_id": null
	});
	
	RpcToClient.update_connected_player_count(connected_clients.size(), MAX_PLAYERS);
	lobby._on_connected_to_server();
	
func _ready():
	assert(lobby);
	assert(host);
	assert(gameobject_manager);
	assert(player_spawn_manager);
	assert(rpc_sender);
	
	_connect_signals();
	_create_server(DEFAULT_PORT, MAX_PLAYERS);
	
	if(is_host):
		_connect_server_as_host();
	else:
		host.queue_free();
	
func _on_client_connect(id):
	PrintHelper.print_server("Client with id(" + str(id) + ") connected to the server");
	
	connected_clients.append({
		"id": id,
		"object_id": null
	});
	
	rpc_sender.update_connected_player_count();
		
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
		rpc_sender.update_connected_player_count();
	else:
		rpc_sender.client_disconnected(client_to_disconnect);

func _on_start_game_button_pressed():
	in_lobby = false;
