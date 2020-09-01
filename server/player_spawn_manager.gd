extends Node

var _spawn_positions = [
	Vector2(200 + 64 * 0, 200),
	Vector2(200 + 64 * 1, 200),
	Vector2(200 + 64 * 2, 200),
	Vector2(200 + 64 * 3, 200)
];

var _next_available_spawn_position_index = 0;

func get_next_available_spawn_position() :
	var next = _next_available_spawn_position_index;
	_next_available_spawn_position_index += 1;
	
	return _spawn_positions[next];