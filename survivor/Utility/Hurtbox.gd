extends Area2D

enum HURT_BOX_TYPE {COOLDOWN, HIT_ONCE, DISABLE_HIT_BOX}

export(HURT_BOX_TYPE) var HurtBoxType = HURT_BOX_TYPE.COOLDOWN

onready var collision = $CollisionShape2D
onready var disableTimer = $DisableTimer

signal hurt(damage)

func _on_Hurtbox_area_entered(area):
	if area.is_in_group("attack"):
		if area.get("damage") != null:
			match HurtBoxType:
				HURT_BOX_TYPE.COOLDOWN:
					collision.call_deferred('set', "disabled", true)
					disableTimer.start()
				HURT_BOX_TYPE.HIT_ONCE:
					pass
				HURT_BOX_TYPE.DISABLE_HIT_BOX:
					if area.has_method("temp_disable"):
						area.temp_disable()
			var damage = area.damage
			emit_signal("hurt", damage)


func _on_DisableTimer_timeout():
	collision.call_deferred('set', "disabled", false)
