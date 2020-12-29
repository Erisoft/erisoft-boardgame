extends AnimatedSprite


func _ready() -> void:
	pass

func get_random_bonus():
	randomize()
	var index = randi() % frames.get_frame_count("bonus")
	set_animation("bonus")
	frame = index
	var type : String
	match index:
		0:
			type = "coins"
		1:
			type = "reroll"
			
	Signals.emit_signal("bonus_collected", type)
	print(type)
	return type


func get_random_malus():
	randomize()
	var index = randi() % frames.get_frame_count("malus")
	set_animation("malus")
	frame = index
	var type : String
	match index:
		0:
			type = "tax"
		1:
			type = "bad_reroll"
		
	Signals.emit_signal("bonus_collected", type)
	print(type)
	return type
