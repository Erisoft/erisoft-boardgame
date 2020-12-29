extends Item


var good := false

func use_item():
	Signals.emit_signal("chest_collected", good)
