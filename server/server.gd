extends Node

const DEFAULT_PORT = 31400;
const MAX_PLAYERS = 4;

var rpc_to_client;

var connected_clients = [];
var host_data = {};

func _ready():
	get_tree().connect("network_peer_connected", self, "_on_client_connect");
	
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS);
	get_tree().set_network_peer(peer);
	print("Server created");
	
	#OUTGOING CALLS TO CLIENTS
	rpc_to_client = load("res://rpc/rpc_to_client.tscn").instance();
	get_tree().get_root().call_deferred("add_child", rpc_to_client);
	
	
func _on_client_connect(id):
	print("Client with id(", id, ") connected to the server");
	
	# INCOMING CALLS FROM CLIENTS #
	var rpc_to_server = load("res://rpc/rpc_to_server.tscn").instance();
	rpc_to_server.name = str(id);
	get_tree().get_root().add_child(rpc_to_server);
	
	connected_clients.append(
	{
		"id": id,
		"client": rpc_to_server
	});
	
	rpc_to_client.rpc("connected_player_count", connected_clients.size());