extends LineEdit

func _ready():
	connect("text_changed", self, "_on_text_changed");
	
func _on_text_changed(text):
	var regex = RegEx.new();
	regex.compile("[A-Z]|[a-z]");
	var result = regex.search(text);
	if(result != null):
		self.text = self.text.replace(result.get_string(), "");
		caret_position = self.text.length();