extends Label

func update_player_count(player_count, max_player_count):
	self.text = str(player_count) + "/" + str(max_player_count) + " players connected";