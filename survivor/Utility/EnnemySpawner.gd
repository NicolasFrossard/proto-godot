extends Node2D

class Spawner:
	var time_start:int
	var time_end:int
	var ennemyResourcePath:String
	var ennemy_number:int
	var ennemy_spawn_delay:int
	var spawn_delay_counter:int
	
	func _init(time_start, time_end, ennemyResourcePath, ennemy_number, ennemy_spawn_delay):
		self.time_start = time_start
		self.time_end = time_end
		self.ennemyResourcePath = ennemyResourcePath
		self.ennemy_number = ennemy_number
		self.ennemy_spawn_delay = ennemy_spawn_delay
		self.spawn_delay_counter = 0

var spawners = [
	Spawner.new(0, 60, "res://Ennemy/Ennemy.tscn", 1, 1),
	Spawner.new(5, 60, "res://Ennemy/Ennemy.tscn", 10, 1)
]

onready var player = get_tree().get_nodes_in_group("player")[0]

var time = 0

func _on_Timer_timeout():
	time += 1
	var ennemy_spawns = spawners
	for i in ennemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.ennemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_ennemy = load(str(i.ennemyResourcePath))
				var counter = 0
				while counter < i.ennemy_number:
					var ennemy_spawn = new_ennemy.instance()
					ennemy_spawn.global_position = get_random_position()
					add_child(ennemy_spawn)
					counter += 1

func get_random_position():
	var vpr = get_viewport_rect().size * rand_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up", "down", "right", "left"][randi() % 4]
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
			
	var x_spawn = rand_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = rand_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)
