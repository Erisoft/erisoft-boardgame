extends Position2D

onready var label = $Label
onready var tween = $Tween

var amount := 0
var text 
var type = ""

var velocity = Vector2(0, 0)
var max_size = Vector2(1, 1)


func _ready() -> void:
	label.set_text(str(amount))
	match type:
		"Gold":
			label.set("custom_colors/font_color", Color.green)
		"Tax":
			max_size = Vector2(1.5, 1.5)
			label.set("custom_colors/font_color", Color.red)
		"Text":
			label.set_text(text)
			max_size = Vector2(1.5, 1.5)
			label.set("custom_colors/font_color", Color.purple)
#		"Heal":
#			label.set("custom_colors/font_color", Color.green)
#		"Damage":
#			label.set("custom_colors/font_color", Color.orangered)
#		"Critical":
#			max_size = Vector2(1.5, 1.5)
#			label.set("custom_colors/font_color", Color.red)
#		"Poison":
#			label.set("custom_colors/font_color", Color.violet)
	
	randomize()
	var side_movement = randi() % 30 -20#41 -20
	velocity = Vector2(side_movement, 30)
	tween.interpolate_property(self, "scale", scale, max_size, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, "scale", max_size, Vector2(0.1, 0.1), 0.7, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.3)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	self.queue_free()


func _process(delta: float) -> void:
	position -= velocity * delta
