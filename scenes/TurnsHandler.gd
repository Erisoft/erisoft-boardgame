extends Node

#sorts the turns of the pawns in game
onready var parent = get_parent()

var pawns := []
var turn_index := 0
var turn_count := 1 setget set_turn_count, get_turn_count
func set_turn_count(value):
	if !value < 0 or !value > 999:
		turn_count = value
func get_turn_count():
	return turn_count
	
var count := 0
var current  setget set_current, get_current
#store the current pawn that hasn't moved
func set_current(value):
	current = value
func get_current():
	return current



func _ready() -> void:
# warning-ignore:return_value_discarded
	Signals.connect("pawn_moved", self, "on_Pawn_moved")
	reset()

#	call_deferred("reset")
#	yield(get_tree().create_timer(1), "timeout")
#	for i in range(20):
#		set_next_pawn()
#		yield(get_tree().create_timer(1), "timeout")
#		has_moved()
#		yield(get_tree().create_timer(1), "timeout")
#		is_turn_over()

func update_pawns_list():
	#function that must be called when a new pawn spawn
	pawns = $Pawns.get_children()


func reset():
	pawns = $Pawns.get_children()
	current = pawns[0]
#	current = pawns.get_child(0)
	reset_moves()
#	print("starting pawn: ", pawns[0].id)


func has_moved(pawn):  #set the moved bool of a pawn as true
#	for p in pawns.get_children():
	for p in pawns:
		if pawn == p:
			p.moved = true
			print(p.pawn_name, " has moved!")
			

func set_turn_to_player():
	#force to set the actual turn straight to the player
	current = $Pawns.get_pawn("player")
	print("Turn to player: ", current.pawn_name)


func get_next_pawn():
	#loop through the array, finds the first element that hasn't moved yet and return it
#	if turn_index < pawns.get_children().size() -1:
	print("pawns size: ", pawns.size())
	turn_index += 1
	if turn_index > pawns.size() -1:
		turn_index = 0
	
	current = pawns[turn_index]
#	current = pawns.get_child(turn_index)
#	print("current : ", pawns.get_child(turn_index), " turn index: ", turn_index)


func is_turn_over() -> void:
#	var total = pawns.get_children().size()
	var total = pawns.size()
	var _is_over : bool
#	for pawn in pawns.get_children():
	for pawn in pawns:
		if pawn.moved == true:
			count += 1
#			print(current.id, " has moved. Count: ", count)
		if count == total:
#			print("Turn is over! Resetting...")
#			print("Total: ", total, " count: ", count)
			count = 0
			turn_count += 1
#			print("turn count: ", turn_count)
			reset_moves()
			_is_over = true
		else:
#			print("Turn not over yet")
#			print("Total: ", total, " count: ", count)
			_is_over = false
#	return is_over 


func reset_moves():
#	for pawn in pawns.get_children():
	for pawn in pawns:
		pawn.moved = false


func reset_pawns():
	#probably useless func
#	for pawn in pawns.get_children():
	for pawn in pawns:
		pawn.index = 0
		pawn.position = parent.board[pawn.index].position
		pawn.moved = false
		pawn.remove_dice()


func on_Pawn_moved(current_pawn):
	current = current_pawn
	has_moved(current)
	is_turn_over()

