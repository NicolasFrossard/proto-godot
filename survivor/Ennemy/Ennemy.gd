extends KinematicBody2D

export var movement_speed = 20.0
export var hp = 10

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("walk")

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	var velocity = direction * movement_speed
	move_and_slide(velocity)

	# Face left or right, depending on velocity
	if (velocity.x > 0):
		sprite.flip_h = true
	elif (velocity.x < 0):
		sprite.flip_h = false


func _on_Hurtbox_hurt(damage):
	hp -= damage
	print('Ennemy hp is now ' + str(hp))
	if hp <= 0:
		queue_free()
