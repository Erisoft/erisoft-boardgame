extends Node2D


export var rigged := false
export var fixed_result : int = 0

var dice_faces = [1, 2, 3, 4, 5, 6]
var dice_result
#onready var parent = get_parent()
#var parent_id


func _enter_tree() -> void:
	if !rigged:
		$DecreaseButton.visible = false
		$IncreaseButton.visible = false
	elif rigged:
		$DecreaseButton.visible = true
		$IncreaseButton.visible = true


func _ready() -> void:
	$Sprite.frame = 5


func roll():
	$Sprite/AnimationPlayer.play("roll")
	$sfx_jump.play()


func _roll_result(rigged : bool):
	randomize()
	if !rigged:
		var index = randi() % dice_faces.size()
		dice_result = dice_faces[index]
	else:
		dice_result = fixed_result

	$Sprite.frame = dice_result - 1
	Signals.emit_signal("dice_rolled", dice_result)
	print("rolled a ", dice_result)


func set_dice_side(value):
	$Sprite.frame = value - 1


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	if _anim_name == "roll":
		$Sprite/AnimationPlayer.stop(true)
		_roll_result(rigged)


func _on_TextureButton_pressed() -> void:
	$TextureButton.disabled = true
	roll()


func roll_only():
	#used as decoration for title screen, pause, etc
	$Sprite/AnimationPlayer.get_animation("roll").loop = true
	$Sprite/AnimationPlayer.play("roll")



func _on_DecreaseButton_pressed() -> void:
	fixed_result -= 1
	if fixed_result < 0:
		fixed_result = 0
	set_dice_side(fixed_result)
#	print("decreasing ", fixed_result)


func _on_IncreaseButton_pressed() -> void:
	fixed_result += 1
	if fixed_result > dice_faces.size():
		fixed_result = dice_faces.size()
	set_dice_side(fixed_result)
#	print("increasing ", fixed_result)
