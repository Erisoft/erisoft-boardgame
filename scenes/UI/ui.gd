extends CanvasLayer

var scree_message_scene = load("res://scenes/entities/ScreenMessage.tscn")

var cursor_image = load("res://assets/Sprites/Cursor.png")

onready var message_label = $Control/Bottom/HBoxContainer/PanelContainer/MessageLabel
onready var coin_label = $Control/Bottom/HBoxContainer/TextureRect/HBoxContainer/UICoin/Value
onready var heart_label = $Control/Bottom/HBoxContainer/TextureRect/HBoxContainer/UIHeart/Value
onready var turn_label = $Control/Top/TextureRect/Turns/ValueLabel
onready var loop_label = $Control/Top/TextureRect/Laps/ValueLabel
onready var screen_message = $Control/ScreenMessage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_image) #Input.CURSOR_ARROW, Vector2(32, 32))
	update_coins(0)
	update_hearts(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func update_coins(amount):
	coin_label.text = str(amount)


func update_hearts(amount):
	heart_label.text = str(amount)


func spawn_screen_message(text : String):
	var sm = scree_message_scene.instance()
	sm.text = text
	$CenterContainer.add_child(sm)
	
	
func show_screen_message(text : String):
	screen_message.label.text = text
	screen_message.visible = true
	screen_message.anim.play("show_msg")


func show_game_message(_text):
	message_label.text = _text


func _on_RestartButton_pressed() -> void:
	get_tree().reload_current_scene()
