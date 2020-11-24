extends Node2D


onready var UI = $UI
onready var camera = $Camera2D
onready var turns_handler = $TurnsHandler

var chest = load("res://scenes/objects/Chest.tscn")

var dice_faces = [1,2,3,4,5,6]
var board = []
var pawns = []
var game_over := true
var move := false

var current_pawn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("dice_rolled", self, "on_Dice_rolled")
	Signals.connect("item_collected", self, "on_Item_collected")
	randomize()
	board = $Tiles.get_children()
#	pawns = $Pawns.get_children()
	UI.hide_ui()


func _process(_delta: float) -> void:
	current_pawn = turns_handler.get_current()
	if current_pawn != null and !game_over:
		camera.position = current_pawn.position


func on_Dice_rolled(parent_id, dice_result) -> void:
	print(parent_id, " rolled ", dice_result)
	if !game_over:
		move_pawn(dice_result, false)
		
		
func on_Item_collected(item_type):
	match item_type:
		"Gold":
			current_pawn.credits += 1000
			end_turn()
		"Reroll":
			current_pawn.spawn_dice()
			current_pawn.roll_dice()
			


func on_Turn_start():
	current_pawn = turns_handler.get_current()
	var turn = turns_handler.get_turn_count()
	UI.turn_label.text = str(turn)

#	print("current pawn: ", turns_handler.current.id, "has moved: ", current_pawn.moved)
#	yield(get_tree().create_timer(1.5), "timeout")
#	UI.turn_label.text = ""

	camera.look_at(current_pawn.position)
	yield(get_tree().create_timer(.3), "timeout")
	current_pawn.spawn_dice()

func end_turn():
#	current_pawn.moved = true
	print("turn ended for ", current_pawn.id, " has moved: ", current_pawn.moved)
	Signals.emit_signal("pawn_moved", current_pawn)
	turns_handler.set_next_pawn()
#	turns_handler.is_turn_over()

	on_Turn_start()


func start_game() -> void:
	$Music.play()
	game_over = false
	UI.message_label.text = "Roll the dice!"
	UI.update_ui(0)
	UI.show_ui()
	turns_handler.reset_pawns()
	turns_handler.reset()
	UI.start_button.visible = false
	on_Turn_start()


func move_pawn(_amount : int, reverse : bool) -> void:
	#moves the pawn according to the dice result and then check the tile landed on
	yield(get_tree().create_timer(.5), "timeout")
	current_pawn.remove_dice()
	current_pawn.anim.play("walk")
	if !reverse:
		current_pawn.set_direction("forward")
		for _i in range(_amount):
			move_pawn_forward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.message_label.text = "Advancing " + str(_amount) + " times!"
	elif reverse:
		current_pawn.set_direction("backward")
		for _i in range(_amount):
			print("moving backward times: ", _i, " amount: ", _amount)
			move_pawn_backward(1)
			current_pawn.play_bounce()
			yield(get_tree().create_timer(.5), "timeout")
			UI.message_label.text = "Ouch! \nGoing back " + str(_amount) + " times!"
			
	current_pawn.anim.play("idle")
	check_tile_type(current_pawn.index)

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
	if index  <= 0 and index != -board.size() + 1:
		index -= step
	else:
		index = 0
	current_pawn.position = board[index].position
	current_pawn.index = index


func check_tile_type(index : int) -> void:
	var tile = $Tiles.get_child(index)

	match tile.type:
		"credits":
			current_pawn.credits_collected(tile.credits)
			end_turn()
		"chest_good":
			spawn_chest(true)
		"chest_bad":
			spawn_chest(false)
		_:
			print_debug("No type found on tile landed.")
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


func end_game() -> void:
	game_over = true
	print("game over")
	UI.start_button.visible = true
	UI.message_label.text = "You won! \nPress Start to play again!"


func _on_StartButton_pressed() -> void:
	start_game()

#for debug purposes
func _on_MoveForward_pressed() -> void:
	move_pawn(3, false)
#	move_pawn_forward(1)
#	check_tile_type(current_pawn.index)


func _on_MoveBackward_pressed() -> void:
	move_pawn(3, true)
#	move_pawn_backward(1)


func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
