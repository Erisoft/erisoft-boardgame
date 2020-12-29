extends Node2D

enum ChestTypes{GOOD, BAD}
export (ChestTypes) var chest_type
export var debug : bool = false

onready var anim = $AnimationPlayer

var anim_speed : float = 1.5
var current_animation := ""

var item_type


func _ready() -> void:
	if !debug:
		$Button.disabled = true
		$Button.visible = false
		$Camera2D.current = false
	else:
		$Button.disabled = false
		$Button.visible = true
		$Camera2D.current = true
		
	randomize()
	$ChestAnimatedSprite.visible = false
	$ChestBonuses.visible = false


func open_chest():
	$ChestAnimatedSprite.visible = true
	
	if chest_type == ChestTypes.GOOD:
		current_animation = "opening_good"
		anim.play(current_animation)
	else:
		current_animation = "opening_bad"
		anim.play(current_animation)


func get_random_item(good : bool):
	#hide all the items sprites, pick a random one and then show it
	var frame
	var anim_name : String
	if good:
		anim_name = "bonus"
		$ChestBonuses.set_animation(anim_name)
	elif !good:
		anim_name = "malus"
		$ChestBonuses.set_animation(anim_name)
	
	frame = $ChestBonuses.get_animation()
#	for sprite in items.get_children():
#		sprite.visible = false
	var index = randi() % frame
	$BonusesAnimatedSprite.frame = index
	$BonusesAnimatedSprite.visible = true
#	for i in items.get_children():
#		i.visible = false
#	items.get_child(index).visible = true
#	item_type = items.get_child(index).type
#	print("Item : ", items.get_child(index).type)
#	var item = items.get_child(index)
#	item.play_animation()
	anim.play("zoom")
#	Signals.emit_signal("item_collected", item_type)
#	self.queue_free()


func _show_bonus() -> void:
	if chest_type == ChestTypes.GOOD:
		$sfx_zoom.pitch_scale = 1
		$ChestBonuses.get_random_bonus()
	else:
		$sfx_zoom.pitch_scale = .4
		$ChestBonuses.get_random_bonus()


func _on_RoundUp_animation_finished(current_animation) -> void:
	if current_animation == "zoom":
		$ChestAnimatedSprite.visible = false
		$ChestBonuses.visible = false

		Signals.emit_signal("item_collected", item_type)
		var action_type = "chest"
		Signals.emit_signal("action_ended", action_type)
		set_camera_current(false)
		anim.stop(true)
		Signals.emit_signal("chest_collected")
		self.queue_free()


func _on_Opening_animation_finished(current_animation) -> void:
	if current_animation == "opening_good" or "opening_bad":
		yield(get_tree().create_timer(.5), "timeout")

		$ChestAnimatedSprite.visible = false
		$ChestBonuses.visible = true
		_show_bonus()
		anim.play("zoom")


func _on_Button_pressed() -> void:
	$Button.visible = false
	open_chest()


func set_camera_current(active):
	if !active:
		$Camera2D.visible = false
		$Camera2D.current = false
	else:
		$Camera2D.visible = true
		$Camera2D.current = true
	
