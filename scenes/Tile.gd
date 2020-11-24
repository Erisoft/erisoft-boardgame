extends Node2D

var good_sprite_chest =  "res://assets/Sprites/Chest Pack 1/Chest Animations/Gold Chest Animation/Gold Chest Frame 2.png"
var bad_sprite_chest = "res://assets/Sprites/Chest Pack 1/Chest Animations/Evil Chest Animation/Evil Chest Frame 2.png"
var animated_coin = "res://scenes/objects/AnimatedCoin.tscn"

class_name Tile

enum NameTypes{CREDITS, CHEST_GOOD, CHEST_BAD, START, SHOP}
export (NameTypes) var nameType = NameTypes.CREDITS

onready var number = $NumberLabel

var type : String
export var credits : int = 100
var moves : int


func _ready() -> void:
	match nameType:
		NameTypes.CREDITS:
			type = "credits"
			$AnimatedSprite.visible = true
			$AnimatedSprite.play("coin")
		NameTypes.START:
			type = "start"
		NameTypes.CHEST_GOOD:
			type = "chest_good"
			$AnimatedSprite.visible = true
			$AnimatedSprite.play("chest_good")
		NameTypes.CHEST_BAD:
			type = "chest_bad"
			$AnimatedSprite.visible = true
			$AnimatedSprite.play("chest_bad")
		NameTypes.SHOP:
			type = "shop"
		_:
			type = ""

