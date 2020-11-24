extends Node2D


enum ItemTypes {GOLD, REROLL, NULL}
export (ItemTypes) var itemType = ItemTypes.GOLD

var type := ""


func _ready() -> void:
	match itemType:
		ItemTypes.GOLD:
			type = "Gold"
		ItemTypes.REROLL:
			type = "Reroll"
		ItemTypes.NULL:
			type = ""
	
	$Label.text = type


func play_animation():
	$AnimatedSprite.play()
