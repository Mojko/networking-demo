extends Node
class_name Client

onready var game = get_node("game");
onready var rpc_client_connector = get_node("rpc_client_connector");

# Make this dynamic later
const SERVER_IP = "127.0.0.1";
const SERVER_PORT = 31400;

var rpc_to_server;
var rpc_to_client;

func _create_client(server_ip, server_port):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(server_ip, server_port);
	var result = get_tree().set_network_peer(peer);
	return result;

func _create_rpc_nodes():
	rpc_to_client = load("res://rpc/rpc_to_client.tscn").instance();
	get_tree().get_root().call_deferred("add_child", rpc_to_client);

func _ready():
	assert(game);
	assert(rpc_client_connector);
	
	var result = _create_client(SERVER_IP, SERVER_PORT);
	_create_rpc_nodes();
	
	print("Client with id(", get_tree().get_network_unique_id(), ") created");
	
	if(result == OK):
		print("Connecting to server...");
	
	rpc_client_connector.connect_rpc_signals(rpc_to_client, game);
	get_tree().connect("connected_to_server", game, "_on_connected_to_server");