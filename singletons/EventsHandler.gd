extends Node

#This script is in charge of handling scripted main events in game
var chest_scene = load("res://scenes/objects/Chest.tscn")

onready var game = $Game
onready var main_camera = $MainCamera
onready var board = $Game/Tiles
onready var turns = $Game/TurnsHandler
onready var pawns = $Game/TurnsHandler/Pawns
onready var UI = $Game/UI

var _pawn
var event_active := false


func _ready() -> void:
	_pawn = turns.get_current()
	Signals.connect("action_ended", self, "on_Action_ended")


func _physics_process(delta: float) -> void:
	main_camera.position = _pawn.global_position
#	current_pawn = turns.get_current()
#	if current_pawn != null and !game.game_over and event_active:
#		main_camera.position = current_pawn.position


func clone_event():
	event_active = true
	pawns.spawn_clone()
	var clone = pawns.get_pawn("clone")
	var player = pawns.get_pawn("player")
	var text = "You summoned an evil clone!"
	clone.position = board.get_child(0).position
	UI.show_screen_message(text)
	yield(get_tree().create_timer(1), "timeout")
	main_camera.position = clone.global_position
	_pawn = clone
#	main_camera.position = clone.global_position
#	doppel.spawn_floating_message("Text", text)
	yield(get_tree().create_timer(2), "timeout")
	event_active = false
	_pawn = player
	Signals.emit_signal("event_ended")
	print("clone event is over.")
#	turns.set_current(current_pawn)
#	game.end_turn()


func chest_event(good : bool):
	event_active = true
	var c = chest_scene.instance()
	var current = turns.get_current()
	current.add_child(c)
	if good:
		c.chest_type = c.ChestTypes.GOOD
	else:
		c.chest_type = c.ChestTypes.BAD
	
	main_camera.current = false
	c.set_camera_current(true)
	c.open_chest()
	
#	game.event_active = false
func on_Action_ended(action_type):
	if action_type == "chest":
		main_camera.current = true
		event_active = false
	
