extends Node2D

var flag_scene = load("res://scenes/objects/items/Flag.tscn")

onready var anim_player = $AnimationPlayer
onready var item = $Items
onready var number = $NumberLabel
onready var parent = get_parent()

#TODO: Clone event will be triggered by another game situation
enum TileTypes{
	NULL, COIN, HEART, STAR, CHEST_GOOD, CHEST_NORMAL, CHEST_BAD,
	START
	}
export (TileTypes) var tileType
enum DirectionTypes{UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3}
export (DirectionTypes) var dir 

var index : int    #gets updated by enumerate_tiles in parent script

var item_name : String

export var _has_item : bool = false setget set_has_item, get_has_item
export var _in_chest : bool = false
var _checkpoint : bool = false setget ,get_checkpoint
func get_checkpoint():
	return _checkpoint


func _ready() -> void:
	init_item_on_tile()
	anim_player.play_backwards("collecting")


func init_item_on_tile():
	item.label.visible = false
	match tileType:
		TileTypes.NULL:
			_has_item = false
			item.visible = false
			anim_player.play("null")
			return
		TileTypes.COIN:
			init_item(true, "coin", true)
		TileTypes.HEART:
			init_item(true, "heart", true)
		TileTypes.STAR:
			init_item(true, "star", true)
		TileTypes.CHEST_GOOD:
			init_item(true, "chest_good", false, 0, true)
		TileTypes.CHEST_NORMAL:
			init_item(true, "chest_normal", false, 0, true)
		TileTypes.CHEST_BAD:
			init_item(true, "chest_bad", false, 0, true)
		TileTypes.START:
			_has_item = true
			item.visible = false
			spawn_flag()
			_checkpoint = true
			anim_player.play("null")
		_:
			printerr("INVALID tile type.")


func init_item(_item : bool, _anim_name : String, _playing : bool, _frame : int = 0, _boxed : bool = false):
	_has_item = _item
	item.animation = _anim_name
	item.playing = _playing
	item.frame = _frame
	_in_chest = _boxed
	item_name = _anim_name
	item.visible = true
	item.modulate.a = 255


func get_item_name():
	return item_name


func get_item():
	if _in_chest == false:
		play_collectable_animation()
		Signals.emit_signal("item_collected", item_name)
	else:
		_open_chest()


func play_collectable_animation():
	anim_player.play("collecting")
	yield(anim_player,"animation_finished")
	_remove_item()


func play_chest_animation():
	print("play_chest_animation called")
	item.z_index = 10
	anim_player.play("opening")


func _remove_item():
	_has_item = false
	item.visible = false


func spawn_flag():
	var flag = flag_scene.instance()
	add_child(flag)
	flag.position = Vector2(5, -10)


func set_has_item(value : bool):
	_has_item = value


func get_has_item():
	return _has_item


func _on_Collectable_Collected():
	play_collectable_animation()
	yield(anim_player,"animation_finished")
	item.visible = false


func _open_chest():
	play_chest_animation()
	yield(anim_player, "animation_finished")
	match tileType:
		TileTypes.CHEST_GOOD:
			calculate_random_item("good")
		TileTypes.CHEST_NORMAL:
			calculate_random_item("normal")
		TileTypes.CHEST_BAD:
			calculate_random_item("bad")


func calculate_random_item(quality : String):
	print("chest quality: ", quality)
	randomize()
	var items = []
	var chest_item
	match quality:
		"good":
			items = ["coins", "hearts", "stars", "reroll"]
		"normal":
			items = ["coins", "hearts"]
		"bad":
			items = ["tax", "reroll_bad"]
			
	chest_item = randi() % items.size()
	print("Chest item: ", items[chest_item])
	item.set_animation(items[chest_item])
	
	match quality:
		"good":
			item.label.text = "x10"
		"normal":
			item.label.text = "x3"
		"bad":
			if chest_item == "tax":
				item.label.text = "-10"
			elif chest_item == "reroll_bad":
				item.label.text = "Bad Reroll"
		
	item.label.visible = true
	item_name = items[chest_item]
	
	anim_player.play("pop_item")
	yield(anim_player, "animation_finished")
	item.visible = false
	_has_item = false
	Signals.emit_signal("item_collected", item_name)
	_remove_item()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pawns"):
		if area.has_method("set_direction"):
			area.set_direction(dir)


#func _on_Pop_Item_animation_finished(anim_name: String) -> void:
#		if anim_name == "pop_item":
#			pass
#
#
#func _on_Collecting_animation_finished(anim_name: String) -> void:
#		if anim_name == "collecting":
#			anim_player.stop()
#			item.z_index = 0


#func _on_Opening_animation_finished(anim_name: String) -> void:
#		if anim_name == "opening":
#			print("opening played")
#			yield(anim_player, "animation_finished")
#			anim_player.play("pop_item")
#			item.label.visible = true
#			item.z_index = 0
#			Signals.emit_signal("item_collected", item_name)
#			print("item_collected emited")
#			anim_player.play("pop_item")
