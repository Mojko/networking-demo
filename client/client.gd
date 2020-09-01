extends Node
class_name Client

onready var input = get_node("input");
onready var ip_edit = get_node("input/VBoxContainer/ip_edit");
onready var port_edit = get_node("input/VBoxContainer/port_edit");
onready var connecting = get_node("connecting");
onready var connection_timed_out = get_node("connection_timed_out");

func _create_client(server_ip, server_port):
	var peer = NetworkedMultiplayerENet.new();
	peer.create_client(server_ip, server_port);
	var result = get_tree().set_network_peer(peer);
	return result;

func _ready():
	assert(input);
	assert(ip_edit);
	assert(port_edit);
	assert(connecting);
	assert(connection_timed_out);
	
	connecting.hide();
	connection_timed_out.hide();
	
	get_tree().connect("connected_to_server", self, "_on_connected_to_server");
	
	if(NetworkGlobals.client_autoconnect):
		_on_connect_pressed();

func _on_connect_pressed():
	var result = _create_client(ip_edit.text, int(port_edit.text));
	
	print(result);
	
	print("Client with id(", get_tree().get_network_unique_id(), ") created");
	
	if(result == OK):
		print("Connecting to server...");
		
	input.hide();
	connecting.show();

func _on_connection_timeout_timeout():
	input.show();
	connecting.hide();
	connection_timed_out.show();
	
func _on_connected_to_server():
	connecting.hide();
	input.hide();
	connection_timed_out.hide();
	connecting.connection_timeout.stop();
