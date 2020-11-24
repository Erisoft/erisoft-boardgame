extends Node2D

enum ChestTypes{GOOD, BAD}
export (ChestTypes) var chest_type

onready var good_items = $GoodItems
onready var bad_items = $BadItems
onready var anim = $AnimationPlayer

var anim_speed : float = 1.5
var current_animation := ""

var item_type


func _ready() -> void:
	randomize()
	$AnimatedSprite.visible = false
	for sprite in good_items.get_children():
		sprite.visible = false
	for sprite in bad_items.get_children():
		sprite.visible = false
		
	open_chest()


func open_chest():
	$AnimatedSprite.visible = true
	current_animation = "opening"
	anim.play(current_animation)
#	$Timer.start()
#	anim.play("roundup", -1, anim_speed)
	

func get_random_item(good : bool):
	#hide all the items sprites, pick a random one and then show it
	var items 
	if good:
		items = good_items
	else:
		items = bad_items 
	for sprite in items.get_children():
		sprite.visible = false
	var index = randi() % items.get_child_count()
	for i in items.get_children():
		i.visible = false
	items.get_child(index).visible = true
	item_type = items.get_child(index).type
	print("Item : ", items.get_child(index).type)
	var item = items.get_child(index)
	item.play_animation()
	anim.play("zoom")
#	Signals.emit_signal("item_collected", item_type)
#	self.queue_free()


func _on_Timer_timeout() -> void:
	if anim_speed  > 0:
		anim_speed -= 0.4
		anim.play("roundup", -1, anim_speed)
	elif anim_speed <= 0:
		anim.stop()
		$Timer.stop()
		if chest_type == ChestTypes.GOOD:
			get_random_item(true)
		else:
			get_random_item(false)
			


func _on_RoundUp_animation_finished(current_animation) -> void:
	if current_animation == "zoom":
		Signals.emit_signal("item_collected", item_type)
		self.queue_free()


func _on_Opening_animation_finished(current_animation) -> void:
	if current_animation == "opening":
		yield(get_tree().create_timer(.5), "timeout")

		$Timer.start()
		anim.play("roundup", -1, anim_speed)


func _on_Button_pressed() -> void:
	open_chest()
	$Button.visible = false
