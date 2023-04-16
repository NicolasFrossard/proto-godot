extends Node2D

onready var _anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	_anim_player.play("Intro_animation")
	$IntroBackground.visible = true
	$ColorRect.visible = true
	yield(_anim_player, "animation_finished")
	get_tree().change_scene("res://scenes/house/house.tscn")
