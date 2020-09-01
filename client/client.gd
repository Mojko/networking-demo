extends Node
class_name Client

onready var game = get_node("game");

# Make this dynamic later
const SERVER_IP = "94.254.18.145";
const SERVER_PORT = 31400;

func _create_client(server_ip, server_port):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(server_ip, server_port);
	var result = get_tree().set_network_peer(peer);
	return result;

func _ready():
	assert(game);
	
	var result = _create_client(SERVER_IP, SERVER_PORT);
	
	print("Client with id(", get_tree().get_network_unique_id(), ") created");
	
	if(result == OK):
		print("Connecting to server...");
	
	get_tree().connect("connected_to_server", game, "_on_connected_to_server");