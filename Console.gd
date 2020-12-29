extends Control


onready var input_box = $Input
onready var output_box = $Output


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_box.grab_focus()


func output_text(text):
	output_box.text = str(output_box.text, "\n", text)


func _on_Input_text_entered(new_text: String) -> void:
	input_box.clear()
	output_text(new_text)
