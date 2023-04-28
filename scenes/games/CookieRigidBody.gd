extends RigidBody2D

var first_touch
var release

signal cooclicked

func _on_TextureButton_pressed():
		print("Emitting signal...")
		emit_signal("cooclicked")

