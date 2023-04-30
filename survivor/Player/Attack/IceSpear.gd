extends Area2D

var level = 1
var hp = 1
var speed = 150
var damage = 5
var knock_amount = 100
var attack_size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg2rad(135) # necessary because spears are rotated 45 degrees per default
	match level:
		1:
			hp = 1
			speed = 100
			damage = 5
			knock_amount = 100
			attack_size = 1.0
	
	# Tween scale from 0.1 to 1 in one second, for small animation when appearing
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1) * attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func _physics_process(delta):
	position += angle * speed * delta

func ennemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		queue_free()

func _on_Timer_timeout():
		queue_free()
