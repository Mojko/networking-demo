extends Label

var _rpc_calls = 0;

func increment():
	_rpc_calls += 1;
	
func _physics_process(delta):
	text = "RPC CALLS: " + str(_rpc_calls);

func _on_rpc_calls_reset_timeout():
	_rpc_calls = 0;
	$rpc_calls_reset.start();
