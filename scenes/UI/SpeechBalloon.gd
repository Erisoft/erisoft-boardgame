extends Sprite

onready var anim_player = $AnimationPlayer
onready var text_label = $Label
onready var timer = $Timer

var text : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_label.set_text(text)
	anim_player.play("pop_in")
	yield(anim_player, "animation_finished")
	timer.start()


func _on_Timer_timeout() -> void:
	anim_player.play("pop_out")


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "pop_out":
		self.queue_free()
