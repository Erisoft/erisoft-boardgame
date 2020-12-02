extends Node2D

#this script will only handle stuffs related to the gameplay like score, credits, etc
onready var events = get_parent()
onready var UI = $UI
onready var turns_handler = $TurnsHandler
onready var pawns = $TurnsHandler/Pawns

var chest = load("res://scenes/objects/Chest.tscn")

var board := []
var game_over := true
var penalty := false
var current_pawn
var _tile 


func _ready() -> void:
	Signals.connect("dice_rolled", self, "on_Dice_rolled")
	Signals.connect("item_collected", self, "on_Item_collected")
	Signals.connect("event_ended", self, "on_Event_ended")
	randomize()
	board = $Tiles.get_children()
	UI.hide_ui()
	turns_handler.call_deferred("reset_pawns")
	turns_handler.call_deferred("update")


func on_Dice_rolled(dice_result) -> void:
	if !game_over and !penalty:
		yield(get_tree().create_timer(.8), "timeout")
		current_pawn.remove_dice()
		move_pawn(dice_result, false)
	else:
		yield(get_tree().create_timer(.8), "timeout")
		current_pawn.remove_dice()
		move_pawn(dice_result, true)
		penalty = false


func on_Item_collected(item_type):
	match item_type:
		"Gold":
			current_pawn.credits_collected(1000)
			end_turn()
		"Reroll":
			current_pawn.spawn_dice()
			current_pawn.roll_dice()
		"Tax":
			current_pawn.tax_collected(500)
			end_turn()
		"Bad Reroll":
			penalty = true
			current_pawn.spawn_dice(false)
			current_pawn.roll_dice()


func on_Turn_start():
	current_pawn = turns_handler.get_current()
	events._pawn = current_pawn
	print("current pawn on start: ", current_pawn.pawn_name)
	var turn = turns_handler.get_turn_count()
	UI.turn_label.text = str(turn)
	UI.show_screen_message(current_pawn.pawn_name +"'s turn")

	yield(get_tree().create_timer(.3), "timeout")
	if current_pawn.is_in_group("Players"):
		current_pawn.spawn_dice(true)   #rigged for debug purposes
	elif current_pawn.is_in_group("Enemies"):
		current_pawn.spawn_dice(false)
		yield(get_tree().create_timer(.5),"timeout")
		current_pawn.roll_dice()


func end_turn():
#	current_pawn.moved = true
	print("turn ended for ", current_pawn.id, " has moved: ", current_pawn.moved)
	Signals.emit_signal("pawn_moved", current_pawn)
	turns_handler.get_next_pawn()
#	turns_handler.is_turn_over()
	yield(get_tree().create_timer(1.3), "timeout")

	on_Turn_start()


func on_Event_ended():
	turns_handler.set_turn_to_player()
	on_Turn_start()
	

func game_start() -> void:
	$Music.play()
	game_over = false
	UI.message_label.text = "Roll the dice!"
	UI.update_ui(0)
	UI.show_ui()
#	turns_handler.reset_pawns()
#	turns_handler.reset()
	UI.start_button.visible = false
#	UI.spawn_screen_message("START!")
	UI.show_screen_message("START!")
	on_Turn_start()
	$Tiles.enabled = true


func move_pawn(_amount : int, reverse : bool) -> void:
	#moves the pawn according to the dice result
	if !reverse:
		for _i in range(_amount):
			move_pawn_forward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.message_label.text = "Advancing " + str(_amount) + " times!"
	elif reverse:
		for _i in range(_amount):
			move_pawn_backward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.message_label.text = "Ouch! \nGoing back " + str(_amount) + " times!"

	get_tile_type(current_pawn.index)
	check_condition()
	print("Actual player position ", current_pawn.index, " pawn turn over: ", current_pawn.moved)


func move_pawn_forward(step) -> void:
	var index =  current_pawn.index
	if index < board.size() - 1:
		index += step
	else:
		index = 0
	current_pawn.position = board[index].position
	current_pawn.index = index


func move_pawn_backward(step) -> void:
	var index =  current_pawn.index
	index -= step
	if index < 0:
		index = board.size() - 1

	current_pawn.position = board[index].position
	current_pawn.index = index


func get_tile_type(index : int) -> String:
	_tile = $Tiles.get_child(index)
	print("landed on tile: ", _tile.type)
	return _tile.type
	
func check_condition():
	match _tile.type:
		"credits":
			current_pawn.credits_collected(_tile.credits)
			end_turn()
		"chest_good":
			events.chest_event(true)
		"chest_bad":
			events.chest_event(false)
		"clone":
			if current_pawn.is_in_group("Players"):
				events.clone_event()
			else:
				end_turn()
		_:
			print_debug("No type found on tile landed.")
			end_turn()
	_tile.empty = true
	_tile.play_animation()


func spawn_chest(good : bool):
	var c = chest.instance()
	current_pawn.add_child(c)
	c.global_position = current_pawn.global_position
	if good:
		c.chest_type = c.ChestTypes.GOOD
	else:
		c.chest_type = c.ChestTypes.BAD
	c.open_chest()


func game_end() -> void:
	game_over = true
	$Tiles.enabled = false
	print("game over")
	UI.start_button.visible = true
	UI.message_label.text = "You won! \nPress Start to play again!"


func _on_StartButton_pressed() -> void:
	game_start()

#for debug purposes
func _on_MoveForward_pressed() -> void:
	move_pawn(1, false)
#	move_pawn_forward(1)
#	check_tile_type(current_pawn.index)


func _on_MoveBackward_pressed() -> void:
	move_pawn(1, true)
#	move_pawn_backward(1)


func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
