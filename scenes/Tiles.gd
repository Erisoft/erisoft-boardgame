extends Node2D

enum ItemTypes {COIN = 0, HEART = 1, CHEST_GOOD = 2, CHEST_BAD = 3}



var item : Item
export var fill_grid := false

var _index : int
var enabled := false
var tiles := []
var checkpoint : bool


func _enter_tree() -> void:
	pass

func _ready() -> void:
	tiles = self.get_children()
	enumerate_tiles()


func enumerate_tiles() -> void:
	#enumerate and update the index value for each tile
#	_index = 0
	for tile in tiles:
		tile.index = _index
		tile.number.text = str(tile.index)
		_index += 1
	
	tiles[0].number.text = str("START")


func reset_items_on_tiles():
	if !checkpoint:
		print("resetting items on tiles...")
		for tile in tiles:
			if tile.get_checkpoint() == false:
				tile.init_item_on_tile()

