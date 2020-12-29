extends Node2D

#this script will only handle stuffs related to the gameplay like score, credits, etc
onready var events = get_parent()
onready var UI = $UI
onready var turns_handler = $TurnsHandler
onready var pawns = $TurnsHandler/Pawns

var chest = load("res://scenes/objects/chest.tscn")

var board := []
var game_over := true
var penalty := false
var current_pawn
var _current_tile 
var item_name : String = ""
var loop : int = -1 #because get set on start
var coins : int = 0
var hearts : int = 0
var star : int = 0


func _ready() -> void:
	Signals.connect("dice_rolled", self, "_on_Dice_Rolled")
	Signals.connect("item_collected", self, "on_Item_collected")
	Signals.connect("event_ended", self, "on_Event_ended")
	Signals.connect("lap_ended", self, "_on_Lap_Ended")
	Signals.connect("coin_collected",self, "on_Coin_collected")
	Signals.connect("heart_collected", self, "_on_Heart_Collected")
	Signals.connect("chest_collected", self, "_on_Chest_Collected")
	randomize()
	board = $Tiles.get_children()
	turns_handler.call_deferred("reset_pawns")
	_start_game()


func _on_Coin_Collected(amount):
	coins += amount
	UI.update_coins(coins)
	end_turn()


func _on_Heart_Collected(amount):
	hearts += amount
	UI.update_hearts(hearts)
	end_turn()


func _on_Star_Collected(amount):
	star += amount
	end_turn()


func _on_Dice_Rolled(dice_result) -> void:
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
	print("on_Item_collected called")
	match item_type:
		"Gold":
			current_pawn.add_coins(10)
			end_turn()
		"Reroll":
			UI.show_game_message("Rolling the dice again!")
			current_pawn.spawn_dice(false)
			current_pawn.roll_dice()
		"Tax":
			UI.show_game_message("Oof! Taxed!")
			current_pawn.remove_coins(5)
			end_turn()
		"Bad Reroll":
			UI.show_game_message("Bad luck!")
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
	print("end_turn called")
	current_pawn.moving = false
	print("turn ended for ", current_pawn.id, " has moved: ", current_pawn.moved)
	Signals.emit_signal("pawn_moved", current_pawn)
	turns_handler.get_next_pawn()
	yield(get_tree().create_timer(1.3), "timeout")

	on_Turn_start()


func on_Event_ended():
	turns_handler.set_turn_to_player()
	on_Turn_start()
	

func _start_game() -> void:
	$Music.play()
	game_over = false
	UI.show_game_message("Roll the dice!")
#	UI.update_ui(0)
#	turns_handler.reset_pawns()
#	turns_handler.reset()
#	UI.spawn_screen_message("START!")
	UI.show_screen_message("START!")
	on_Turn_start()
	$Tiles.enabled = true


func move_pawn(_amount : int, reverse : bool) -> void:
	#moves the pawn according to the dice result
	current_pawn.moving = true
	if !reverse:
		for _i in range(_amount):
			move_pawn_forward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.show_game_message("Advancing " + str(_amount) + " times!")
	elif reverse:
		for _i in range(_amount):
			move_pawn_backward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.show_game_message("Ouch! \nGoing back " + str(_amount) + " times!")
			
	_current_tile = board[current_pawn.index]
	print("Actual player position ", current_pawn.index, " pawn turn over: ", current_pawn.moved)
	check_item_on_tile()


func check_item_on_tile():
	if _current_tile.get_has_item():
		_current_tile.play_animation()
		item_name = board[current_pawn.index].get_item_name()
		match item_name:
			"":
				return
			"coin":
				_on_Coin_Collected(1)
			"heart":
				_on_Heart_Collected(1)
			"star":
				_on_Star_Collected(1)
			"chest_good":
				events.chest_event()
				_on_Chest_Collected("good")
			"chest_normal":
				_on_Chest_Collected("normal")
			"chest_bad":
				_on_Chest_Collected("bad")
				
		_current_tile.set_has_item(false)
	else:
		end_turn()


func _on_Chest_Collected(chest_type : String):
	match chest_type:
		"good":
			pass
		"normal":
			pass
		"bad":
			pass
		_:
			printerr("INVALID chest type.")


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


#func get_tile_type(index : int) -> String:
#	_tile = $Tiles.get_child(index)
#	print("landed on tile: ", _tile.type)
#	return _tile.type
	
#func check_condition():
#	current_pawn.moving = false
#	match _tile.type:
#		"credits":
#			current_pawn.add_coins(_tile.coins)
#			end_turn()
#		"chest_good":
#			events.chest_event(true)
#		"chest_bad":
#			events.chest_event(false)
#		"clone":
#			if current_pawn.is_in_group("Players") and !events.events.clone:
#				events.clone_event()
#			else:
#				end_turn()
#		_:
#			print_debug("No type found on tile landed.")
#			end_turn()
#	_tile.empty = true
#	_tile.play_animation()


func on_Chest_collected(good):
	print("on_Chest_collected called")
#	events.chest_event(good)
	end_turn()

func spawn_chest(good : bool):
	var c = chest.instance()
	current_pawn.add_child(c)
	c.global_position = current_pawn.global_position
	if good:
		c.chest_type = c.ChestTypes.GOOD
	else:
		c.chest_type = c.ChestTypes.BAD
	c.open_chest()


func _on_Lap_Ended():
	if !game_over:
		loop += 1
		UI.loop_label.text = str(loop)
		$Tiles.reset_items_on_tiles()


func game_end() -> void:
	game_over = true
	$Tiles.enabled = false
	print("game over")
#	UI.start_button.visible = true
#	UI.message_label.text = "You won! \nPress Start to play again!"


func _on_StartButton_pressed() -> void:
	_start_game()

#for debug purposes
func _on_MoveForward_pressed() -> void:
	move_pawn(1, false)
#	move_pawn_forward(1)
#	check_tile_type(current_pawn.index)


func _on_MoveBackward_pressed() -> void:
	move_pawn(1, true)
#	move_pawn_backward(1)

