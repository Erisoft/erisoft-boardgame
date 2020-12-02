extends Node2D


enum ItemTypes {GOLD, REROLL, TAX, BAD_REROLL, NULL}
export (ItemTypes) var itemType = ItemTypes.GOLD

var type := ""


func _ready() -> void:
	match itemType:
		ItemTypes.GOLD:
			type = "Gold"
		ItemTypes.REROLL:
			type = "Reroll"
		ItemTypes.TAX:
			type = "Tax"
		ItemTypes.BAD_REROLL:
			type = "Bad Reroll"
		ItemTypes.NULL:
			type = ""
	
	$Label.text = type


func play_animation():
	$AnimatedSprite.play()
