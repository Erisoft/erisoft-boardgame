extends Node2D


onready var col_2d = $Area2D/CollisionShape2D

var dice = [1, 2, 3, 4, 5, 6]
var dice_result
onready var parent = get_parent()
var parent_id


func _ready() -> void:
	if parent != null:
		parent_id = parent.id
	randomize()
	$Sprite.frame = 5

func roll():
	$sfx_jump.play()
	$Sprite/AnimationPlayer.play("roll")
	col_2d.disabled = true
	

func _roll_result():
	var index = randi() % dice.size()
	dice_result = dice[index]


func set_dice_side(value):
	$Sprite.frame = value - 1


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	_roll_result()
	$Sprite.frame = dice_result - 1
	Signals.emit_signal("dice_rolled", parent_id, dice_result)
	col_2d.disabled = false


func _on_Area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("l_click"):
		roll()

