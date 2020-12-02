extends ColorRect

onready var label = $Label
onready var anim = $AnimationPlayer

var text : String = "You forgot to type a message!"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	label.text = str(text)
#	$AnimationPlayer.play("show_msg")
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "show_msg":
		anim.stop(true)
		self.visible = false
#		self.queue_free()
