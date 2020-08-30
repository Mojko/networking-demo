# networking-demo

The architecture in this project is signal-based, and what I mean with that is that all the client does is send out signals whenever an action happends, sending that signal to a RPC manager which can then send that message to the server. This means that, in theory, all you should have to do is take out all the connections to the RPC managers and automaticly have a singleplayer game. 

rpc_to_client.gd takes cares of all the signals to the client
rpc_to_server.gd takes care of all the signals to the server

Feedback on my code is appreciated since I'm new to networking in godot, and pretty new to networking in general!
