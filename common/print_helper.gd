extends Node

var client_prefix = "[CLIENT] - ";
var server_prefix = "[SERVER] - ";

func print_client(message):
	print(client_prefix + message);
	
func print_server(message):
	print(server_prefix + message);