extends Item


func use_item():
	print("collecting coin")
	if !disabled:
		amount = 1
		Signals.emit_signal("coin_collected", amount)
		$AnimationPlayer.play("collect")
