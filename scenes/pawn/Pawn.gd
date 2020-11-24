extends Area2D


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
export var moved := false
export var id : String
export var type : String
var credits : int = 0


func _ready() -> void:
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	anim.play("idle")


#func _physics_process(delta: float) -> void:
#	if direction == Directions.FRONT:
#		$Sprite.flip_h = false
#	elif direction == Directions.BACK:
#		$Sprite.flip_h = true


func roll_dice() -> void:
	$Dice.roll()

func credits_collected(amount):
	credits += amount
	Signals.emit_signal("credits_collected", credits)


func spawn_dice():
	dice = dice_scene.instance()
	self.add_child(dice)
	dice.global_position = self.global_position
	dice.global_position.y = self.global_position.y - 30


func remove_dice():
	if dice != null:
		dice.queue_free()


func set_direction(dir : String):
	if dir == "forward":
		$Sprite.flip_h = false
	elif dir == "backward":
		$Sprite.flip_h = true


func play_bounce():
	$sfx_bounce.play()


func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func move(dir):
	position += inputs[dir] * tile_size
