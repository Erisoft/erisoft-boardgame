extends Node2D

#TileTypes{CREDITS = 0, CHEST_GOOD = 1, CHEST_BAD = 2, START = 3, DOPPELGANGER = 4, SHOP = 5}
export var fill_grid := false
var enabled := false
var good_seed = 6
var bad_seed = 7
var clone_seed = 20
var tiles := []


func _ready() -> void:
	tiles = self.get_children()
	enumerate_tiles()
	
func _physics_process(delta: float) -> void:
	#TODO: needs improvements, for now setting the grid manually
	#Must check every tile type while iterating to avoid repetitions or type overwrites
	if !fill_grid:
		return
	else:
		if good_seed < tiles.size() - 1:
			tiles[good_seed].tileType = 1
			good_seed += 7
			print("good seed value: " , good_seed )
		elif bad_seed < tiles.size() -1:
			tiles[bad_seed].tileType = 2
			bad_seed += 8
		elif clone_seed < tiles.size() - 1:
			tiles[clone_seed].tileType = 4
			clone_seed +=  21
		else:
			fill_grid = false
			for tile in tiles:
				tile.update()
		


func enumerate_tiles() -> void:
	var index := 0
	for tile in tiles:
		index += 1
		tile.number.text = str(index)


func set_good_chests():
	pass
#	while good_seed < tiles.size() -1:
#		tiles[good_seed].tileType = 1
#		good_seed += good_seed
#	var index := 0
#	for tile in tiles:
#		index += 1
#		if index < tiles.size() - 1 and index == good_seed:
#			tile.tileType = 1
#		else:
#			print("no elegible tile found!")
