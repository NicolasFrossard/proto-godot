extends Node2D

func _ready():
	yield(get_tree().create_timer(2), "timeout")
	play_house_dialogue()
	
func play_house_dialogue():
	var dialogue_instance : CanvasLayer = load("res://dialogues/Dialogue.tscn").instance()
	get_tree().current_scene.add_child_below_node($HouseUI, dialogue_instance)
	dialogue_instance.dialogue_file = "res://dialogues/jsons/house.json"
	dialogue_instance.play()
