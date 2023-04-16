extends Control

onready var _anim_player := $StartGameTransitionRect/AnimationPlayer

func _on_QuitGameButton_pressed():
	get_tree().quit()


func _on_StartGameButton_pressed():
	_anim_player.play("Fade")
	yield(_anim_player, "animation_finished")
	get_tree().change_scene("res://scenes/intro/Intro.tscn")
