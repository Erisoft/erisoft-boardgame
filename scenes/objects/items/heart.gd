extends Item


func use_item():
	print("collecting heart")
	if !disabled:
		amount = 1
		Signals.emit_signal("heart_collected", amount)
		$AnimationPlayer.play("collect")
