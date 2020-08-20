extends Node

onready var connecting = get_node("connecting");
onready var ui = get_node("ui");

const SERVER_IP = "127.0.0.1";
const SERVER_PORT = 31400;

var rpc_to_server;
var rpc_to_client;

func _ready():
	ui.hide();
	
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(SERVER_IP, SERVER_PORT);
	var result = get_tree().set_network_peer(peer);
		
	rpc_to_server = load("res://rpc/rpc_to_server.tscn").instance();
	rpc_to_server.name = str(get_tree().get_network_unique_id());
	get_tree().get_root().call_deferred("add_child", rpc_to_server);
	
	rpc_to_client = load("res://rpc/rpc_to_client.tscn").instance();
	get_tree().get_root().call_deferred("add_child", rpc_to_client);
	rpc_to_client.connect("connected_player_count", self, "_recieve_connected_player_count");
	
	print("Client with id(", get_tree().get_network_unique_id(), ") created");
	
	if(result == OK):
		print("Connecting to server...");
	
	get_tree().connect("connected_to_server", self, "_on_connected_to_server");
	
func _process(delta):
	if(Input.is_action_just_pressed("ui_down")):
		print("Sending to server...");
		rpc_to_server.rpc_id(1, "wew", "From Client to Server");
	
func _on_connected_to_server():
	print("Connected to server");
	connecting.queue_free();
	ui.show();
	
	rpc_to_server.rpc_id(1, "wew", "From Client to Server");
	
func _recieve_connected_player_count(player_count):
	get_node("ui/Label2").text = str(player_count) + "/4 players";
	