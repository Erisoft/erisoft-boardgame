extends Node2D



#notify Tiles node when player complete a loop
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("Players"):
		Signals.emit_signal("lap_ended")
