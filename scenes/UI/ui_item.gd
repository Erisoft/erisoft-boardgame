tool
extends NinePatchRect

enum IconTypes {NULL, COIN, HEART, STAR}
export (IconTypes) var iconType 
onready var label = $Value
onready var item = $Items


func _ready() -> void:
	match iconType:
		IconTypes.NULL:
			item.visible = false
		IconTypes.COIN:
			item.animation = "coin"
		IconTypes.HEART:
			item.animation = "heart"
		IconTypes.STAR:
			item.animation = "star"
