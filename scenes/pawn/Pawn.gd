extends Area2D

var floating_text_scene = load("res://scenes/entities/FloatingText.tscn")
var speech_balloon_scene = load("res://scenes/UI/SpeechBalloon.tscn")

var tile_size = 64
var inputs = {"right" : Vector2.RIGHT,
"left" : Vector2.LEFT,
"up" : Vector2.UP,
"down" : Vector2.DOWN}

var dice_scene = load("res://scenes/dice/Dice.tscn")
var dice

onready var sprite = $Sprite
onready var anim = $AnimationPlayer

var index := 0
export var moving := false
export var moved := false
export var pawn_name : String
export var id : int
export var type : String
var coins : int = 0
var hearts : int = 0


func _ready() -> void:
#	position = position.snapped(Vector2.ONE * tile_size)
#	position += Vector2.ONE * tile_size/2
	anim.play("idle")
	spawn_balloon("Happy Holydays by ERISOFT!")


func spawn_dice(fixed : bool):
	dice = dice_scene.instance()
	if !fixed:
		dice.rigged = false
	elif fixed:
		dice.rigged = true
		
	self.add_child(dice)
	dice.global_position = self.global_position
	dice.global_position.y = self.global_position.y - 30


func roll_dice() -> void:
	dice.roll()


func add_coins(amount):
	coins += amount
	Signals.emit_signal("coin_collected", coins)
	spawn_floating_text("Gold", amount)
	
func add_hearts(amount):
	hearts += amount
	Signals.emit_signal("heart_collected", hearts)
	spawn_floating_text("Heart", amount)


func remove_coins(amount):
	coins -= amount
	Signals.emit_signal("coin_collected", coins)
	spawn_floating_text("Tax", amount)
	

func remove_hearts(amount):
	hearts -= amount


func spawn_floating_text(_type = "", _amount = 0):
	var ft = floating_text_scene.instance()
	ft.type = _type
	ft.amount = _amount
	self.add_child(ft)


func remove_dice():
	if dice != null:
		dice.queue_free()

#0 = UP, 1 = DOWN, 2 = LEFT, 3 = RIGHT
func set_direction(dir):
	if dir == 0:
		$Sprite.flip_h = false
		anim.play("up")
	elif dir == 1:
		anim.play("idle")
		$Sprite.flip_h = false
	elif dir == 2:
		anim.play("walk")
		$Sprite.flip_h = true
	elif dir == 3:
		anim.play("walk")
		$Sprite.flip_h = false


func play_bounce():
	$sfx_bounce.play()


func light_on(value):
	if !value:
		$Light2D.enabled = false
	else:
		$Light2D.enabled = true


func spawn_floating_message(_type, _text):
	var ft = floating_text_scene.instance()
	ft.type = _type
	ft.text = _text
	self.add_child(ft)


func spawn_balloon(_text: String):
	var sp = speech_balloon_scene.instance()
	sp.text = _text
	sp.position = self.position
	sp.position = Vector2(16, -16)
	self.add_child(sp)


func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * tile_size


func can_pick():
	if moving:
		return false
	else:
		return true

