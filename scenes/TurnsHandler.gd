extends Node


onready var parent = get_parent()

var turn_index := 0
var turn_count := 1 setget set_turn_count, get_turn_count
func set_turn_count(value):
	if !value < 0 or !value > 999:
		turn_count = value
func get_turn_count():
	return turn_count
	
var pawns := []
var count := 0
var current  setget set_current, get_current
#store the current pawn that hasn't moved
func set_current(value):
	current = value
func get_current():
	return current


func _ready() -> void:
	Signals.connect("pawn_moved", self, "on_Pawn_moved")
	pawns = self.get_children()
	reset()
#	yield(get_tree().create_timer(1), "timeout")
#	for i in range(20):
#		set_next_pawn()
#		yield(get_tree().create_timer(1), "timeout")
#		has_moved()
#		yield(get_tree().create_timer(1), "timeout")
#		is_turn_over()

func reset():
	current = pawns[0]
	reset_moves()
#	print("starting pawn: ", pawns[0].id)


func has_moved(pawn):  #set the moved bool of a pawn as true
	for p in pawns:
		if pawn == p:
			p.moved = true
			print(p, " has moved!")
			

func set_next_pawn():
	#loop through the array, finds the first element that hasn't moved yet and return it
	if turn_index < pawns.size() -1:
		turn_index += 1
	else:
		turn_index = 0
	
	current = pawns[turn_index]
	print("current : ", pawns[turn_index].id , " turn index: ", turn_index)


func is_turn_over() -> bool:
	var total = pawns.size()
	var is_over : bool
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
			is_over = true
		else:
#			print("Turn not over yet")
#			print("Total: ", total, " count: ", count)
			is_over = false
	return is_over 


func reset_moves():
	for pawn in pawns:
		pawn.moved = false


func reset_pawns():
	#probably useless func
	for pawn in pawns:
		pawn.index = 0
		pawn.position = parent.board[pawn.index].position
		pawn.moved = false
		pawn.remove_dice()


func on_Pawn_moved(current_pawn):
	current = current_pawn
	has_moved(current)
	is_turn_over()

