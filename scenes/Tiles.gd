extends Node2D



func _ready() -> void:
	enumerate_tiles()


func enumerate_tiles() -> void:
	var index := 0
	for tile in self.get_children():
		index += 1
		tile.number.text = str(index)
