extends Control

export var game_scene_path : String = "res://scenes/game.tscn"
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Deco/Dice.roll_only()
	$Deco/Dice2.roll_only()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_StartButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().change_scene(game_scene_path)
