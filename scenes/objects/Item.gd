extends Node2D
class_name Item

export var disabled : bool
export var amount : int


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if disabled:
		disable_item()
	else:
		enable_item()


func use_item():
	z_index = 1
	print("z index: ", z_index)
	pass


func enable_item():
	pass


func disable_item():
	pass


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	$AnimationPlayer.stop(true)
	z_index = 0
	print("z index: ", z_index)
	queue_free()
