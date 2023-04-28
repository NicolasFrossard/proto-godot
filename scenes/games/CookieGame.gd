extends Node2D

signal game_success

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode != KEY_ENTER:
			emit_signal("game_success")
			queue_free()
