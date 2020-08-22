extends Node
class_name Client

onready var game = get_node("game");
onready var rpc_client_connector = get_node("rpc_client_connector");

# Make this dynamic later
const SERVER_IP = "127.0.0.1";
const SERVER_PORT = 31400;

func _create_client(server_ip, server_port):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(server_ip, server_port);
	var result = get_tree().set_network_peer(peer);
	return result;

func _ready():
	assert(game);
	assert(rpc_client_connector);
	
	var result = _create_client(SERVER_IP, SERVER_PORT);
	
	print("Client with id(", get_tree().get_network_unique_id(), ") created");
	
	if(result == OK):
		print("Connecting to server...");
	
	rpc_client_connector.connect_rpc_signals(RpcToClient, game);
	get_tree().connect("connected_to_server", game, "_on_connected_to_server");