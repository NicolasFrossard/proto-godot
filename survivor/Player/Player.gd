extends KinematicBody2D

var speed = 80  # speed in pixels/sec
var velocity = Vector2.ZERO
var hp = 80

onready var sprite = $Sprite
onready var walkTimer = get_node("WalkTimer")

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	# Make sure diagonal movement isn't faster: use normalized
	velocity = velocity.normalized() * speed

func _physics_process(_delta):
	get_input()
	
	# Face left or right, depending on velocity
	if (velocity.x > 0):
		sprite.flip_h = true
	elif (velocity.x < 0):
		sprite.flip_h = false
		
	if (velocity != Vector2.ZERO):
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame = 1
			walkTimer.start()
	
	velocity = move_and_slide(velocity)
	


func _on_Hurtbox_hurt(damage):
	hp -= damage
	print(hp)
