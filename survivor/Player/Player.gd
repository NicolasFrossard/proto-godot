extends KinematicBody2D

var speed = 80  # speed in pixels/sec
var velocity = Vector2.ZERO
var hp = 80

# Attacks
var iceSpear = preload("res://Player/Attack/IceSpear.tscn")

# AttackNodes
onready var iceSpearTimer = get_node("Attack/IceSpearTimer")
onready var iceSpearAttackTimer = get_node("Attack/IceSpearTimer/IceSpearAttackTimer")

# IceSpear
var icespear_ammo = 0
var icespear_base_ammo = 1
var icespear_attackspeed = 1.5
var icespear_level = 1

# Ennemy related
var ennemy_close = []

onready var sprite = $Sprite
onready var walkTimer = get_node("WalkTimer")

func _ready():
	attack()
	
func attack():
	if (icespear_level > 0):
		iceSpearTimer.wait_time = icespear_attackspeed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()

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

func _on_IceSpearTimer_timeout():
	icespear_ammo += icespear_base_ammo
	iceSpearAttackTimer.start()

func _on_IceSpearAttackTimer_timeout():
	if icespear_ammo > 0:
		var icespear_attack = iceSpear.instance()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		get_tree().get_root().get_node("World").add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()
		
func get_random_target():
	if ennemy_close.size() > 0:
		return ennemy_close[randi() % ennemy_close.size()].global_position
	else:
		return Vector2.RIGHT

func _on_EnnemyDetectionArea_body_entered(body):
	if not ennemy_close.has(body):
		ennemy_close.append(body)

func _on_EnnemyDetectionArea_body_exited(body):
	if ennemy_close.has(body):
		ennemy_close.erase(body)
