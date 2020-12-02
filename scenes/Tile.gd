extends Node2D


onready var number = $NumberLabel
onready var parent = get_parent()

enum DirectionTypes{UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}
export (DirectionTypes) var dir 

enum TileTypes{CREDITS, CHEST_GOOD, CHEST_BAD, START, DOPPELGANGER, SHOP}
export (TileTypes) var tileType = TileTypes.CREDITS


var type : String
export var credits : int = 100
var moves : int
export var empty : bool = false


func _ready() -> void:
	for item in $Items.get_children():
		item.visible = false
	update()


func clear_tile():
	for item in $Items.get_children():
		item.visible = false


func play_animation():
	$Items.z_index = 1
	$AnimationPlayer.play("zoom")


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pawns"):
		area.set_direction(dir)
		if tileType == TileTypes.START and parent.enabled and area.is_in_group("Players"):
			#TODO: create a checkpoint system to reset the grid items and maybe
			#give player a special bonus or w/e
			print("a pawn stepped on checkpoint flag")



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "zoom":
		$Items.z_index = 0
		$AnimationPlayer.stop(true)
		clear_tile()

func update():
	match tileType:
		TileTypes.CREDITS:
			type = "credits"
			$Items/Coin.visible = true
			empty = false
		TileTypes.START:
			type = "start"
			empty = true
			$Items/StartSprite.visible = true
		TileTypes.CHEST_GOOD:
			type = "chest_good"
			$Items/ChestAnimatedSprite.animation = "good_chest"
			$Items/ChestAnimatedSprite.visible = true
#			$AnimatedSprite.play("chest_good")
			empty = false
		TileTypes.CHEST_BAD:
			type = "chest_bad"
			$Items/ChestAnimatedSprite.animation = "bad_chest"
			$Items/ChestAnimatedSprite.visible = true
#			$AnimatedSprite.play("chest_bad")
			empty = false
		TileTypes.SHOP:
			type = "shop"
		TileTypes.DOPPELGANGER:
			type = "clone"
			$Items/CloneSprite.visible = true
			empty = false
		_:
			type = ""
