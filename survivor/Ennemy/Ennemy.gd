extends KinematicBody2D

export var movement_speed = 20.0

onready var player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var velocity = direction * movement_speed
	move_and_slide(velocity)