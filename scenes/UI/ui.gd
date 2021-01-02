extends CanvasLayer


var cursor_image = load("res://assets/Sprites/Cursor.png")

onready var message_label = $Control/BottomRight/PanelContainer/MessageLabel
onready var ui_coin= $Control/BottomLeft/HBoxContainer/TextureRect/HBoxContainer/UIItemCoin
onready var ui_heart = $Control/BottomLeft/HBoxContainer/TextureRect/HBoxContainer/UIItemHeart
onready var ui_star = $Control/BottomLeft/HBoxContainer/TextureRect/HBoxContainer/UIItemStar
onready var turn_label = $Control/TopCenter/TextureRect/Turns/ValueLabel
onready var loop_label = $Control/TopCenter/TextureRect/Laps/ValueLabel
onready var screen_message = $Control/ScreenMessage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# warning-ignore:return_value_discarded
	Signals.connect("coin_collected", self, "update_coins")
# warning-ignore:return_value_discarded
	Signals.connect("heart_collected", self, "update_hearts")
# warning-ignore:return_value_discarded
	Signals.connect("star_collected", self, "update_stars")
	Input.set_custom_mouse_cursor(cursor_image) #Input.CURSOR_ARROW, Vector2(32, 32))
	update_coins(0)
	update_hearts(0)
	update_stars(0)


func update_coins(amount):
	ui_coin.label.text = str(amount)


func update_hearts(amount):
	ui_heart.label.text = str(amount)


func update_stars(amount):
	ui_star.label.text = str(amount)


#func spawn_screen_message(text : String):
#	var sm = scree_message_scene.instance()
#	sm.text = text
#	$CenterContainer.add_child(sm)
	
	
func show_screen_message(text : String):
	screen_message.label.text = text
	screen_message.visible = true
	screen_message.anim.play("show_msg")


func show_game_message(_text):
	message_label.text = _text


func _on_RestartButton_pressed() -> void:
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()


func _on_CloneButton_pressed() -> void:
	get_parent().get_parent().clone_event()
