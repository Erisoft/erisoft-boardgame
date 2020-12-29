tool
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
enum ItemTypes {COLLECTABLE, BOXED}
var itemType

var index : int    #gets updated by enumerate_tiles in parent script

var item_name : String

export var _has_item : bool = false setget set_has_item, get_has_item
var _checkpoint : bool = false setget ,get_checkpoint
func get_checkpoint():
	return _checkpoint


func _ready() -> void:
	init_item_on_tile()


func init_item_on_tile():
	match tileType:
		TileTypes.NULL:
			_has_item = false
			$Items.visible = false
			return
		TileTypes.COIN:
			init_item(true, "coin", true)
		TileTypes.HEART:
			init_item(true, "heart", true)
		TileTypes.STAR:
			init_item(true, "star", true)
		TileTypes.CHEST_GOOD:
			init_item(true, "chest_good", false, 0)
		TileTypes.CHEST_NORMAL:
			init_item(true, "chest_normal", false, 0)
		TileTypes.CHEST_BAD:
			init_item(true, "chest_bad", false, 0)
		TileTypes.START:
			_has_item = true
			item.visible = false
			spawn_flag()
			_checkpoint = true
		_:
			printerr("INVALID tile type.")


func init_item(_item : bool, _anim_name : String, _playing : bool, _frame : int = 0, _boxed : bool = false):
	_has_item = _item
	item.animation = _anim_name
	item.playing = _playing
	item.frame = _frame
	item_name = _anim_name
	if _boxed == true:
		itemType = ItemTypes.BOXED
	else:
		itemType = ItemTypes.COLLECTABLE
	item.visible = true
	item.modulate.a = 255


func get_item_name():
	return item_name


func play_animation():
	item.z_index = 10
	if itemType == ItemTypes.COLLECTABLE:
		anim_player.play("collecting", true)
	elif itemType == ItemTypes.BOXED:
		anim_player.play("opening", true)


func remove_item():
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


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Pawns"):
		if area.has_method("set_direction"):
			area.set_direction(dir)



func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "collecting" or "opening":
		item.z_index = 0
