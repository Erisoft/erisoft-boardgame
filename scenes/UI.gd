extends CanvasLayer

var scree_message_scene = load("res://scenes/entities/ScreenMessage.tscn")

var cursor_image = load("res://assets/Sprites/Cursor.png")

onready var start_button = $StartButton
onready var message_label = $PanelContainer/Panel/MessageLabel
onready var credits_label = $PanelContainer/Panel/CreditsLabel
onready var turn_label = $TopMarginContainer/TurnPanelContainer/Panel/Turns/ValueLabel
onready var screen_message = $ScreenMessage


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.connect("credits_collected",self, "on_Credits_collected")
	Input.set_custom_mouse_cursor(cursor_image) #Input.CURSOR_ARROW, Vector2(32, 32))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func update_ui(amount):
	credits_label.text = str(amount)

func on_Credits_collected(credits):
	update_ui(credits)


func hide_ui():
	$TopMarginContainer.visible = false
	$PanelContainer.visible = false


func show_ui():
	$TopMarginContainer.visible = true
	$PanelContainer.visible = true
	

func spawn_screen_message(text : String):
	var sm = scree_message_scene.instance()
	sm.text = text
	$CenterContainer.add_child(sm)
	
	
func show_screen_message(text : String):
	screen_message.label.text = text
	screen_message.visible = true
	screen_message.anim.play("show_msg")
