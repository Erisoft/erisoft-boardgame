extends Item


var good := true

func use_item():
	Signals.emit_signal("chest_collected", good)
