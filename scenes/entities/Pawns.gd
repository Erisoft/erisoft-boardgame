extends Node2D

#a node holding all the pawns in game, allowing to spawn or get pawns in
onready var parent = get_parent()

var pawn_scene = load("res://scenes/pawn/Pawn.tscn")
var player_scene = load("res://scenes/pawn/Player.tscn")
var clone_scene = load("res://scenes/pawn/clone.tscn")

var pawns_index := 0

func _ready() -> void:
	spawn_player()
	parent.reset()


func spawn_player():
	var p = player_scene.instance()
	p.id = pawns_index + 1
	p.pawn_name = "player"
	p.add_to_group("Players")
	self.add_child(p)
	parent.update_pawns_list()
	
	
func spawn_clone():
	var d = clone_scene.instance()
	self.add_child(d)
	d.id = pawns_index + 1
	d.pawn_name = "clone"
	d.add_to_group("Enemies")
	parent.update_pawns_list()


func spawn_pawn(id : int):
	var p = pawn_scene.instance()
	p.id = id
	self.add_child(p)
	parent.update_pawns_list()


func get_pawn(_name):
	#find and get a pawn by name
	for pawn in self.get_children():
		if pawn.pawn_name == _name:
			return pawn
