extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file

onready var _anim_player := $MarginContainer/AnimationPlayer

var dialogue = null
var next_script_index = 0

var current_script_entry = null

func play():
	$ChoiceContainer.visible = false
	dialogue = load_dialogue()
	$LeftPortrait.texture = load(dialogue.left_portrait)
	$RightPortrait.texture = load(dialogue.right_portrait)
	read_line()

func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())

func _on_Button_pressed():
	if ('next_action' in current_script_entry && current_script_entry.next_action == 'QUIT_GAME'):
		get_tree().quit()

	next_line()

func next_line():	
	var entries_count = len(dialogue.entries)
	if (next_script_index >= entries_count):
		return
		
	read_line()

func read_line():
	current_script_entry = dialogue.entries[next_script_index]
	
	if ('next_label' in current_script_entry):
		$MarginContainer/ColorRect/NextButton.text = current_script_entry.next_label
	else:
		$MarginContainer/ColorRect/NextButton.text = '> Next'
	
	next_script_index += 1 # May be changed in case of choices
	
	if (current_script_entry.mode == 'narration'):
		read_narration_line()
	
	if (current_script_entry.mode == 'conversation'):
		read_conversation_line()
		
	if (current_script_entry.mode == 'choice'):
		toggle_choice_mode(true)
		read_choice_line()
	
	if (current_script_entry.mode == 'game'):
		toggle_choice_mode(true)
		play_open_box_animation(true)
		yield(_anim_player, "animation_finished")
		var game_instance : Node2D = load(current_script_entry.resource).instance()
		add_child(game_instance)

func toggle_choice_mode(toggle):
	$LeftPortrait.visible = !toggle
	$RightPortrait.visible = !toggle
	$MarginContainer/ColorRect/NameNode.visible = !toggle
	$MarginContainer/ColorRect/TextNode.visible = !toggle
	$MarginContainer/ColorRect/NextButton.visible = !toggle

func read_narration_line():
		$LeftPortrait.visible = false
		$RightPortrait.visible = false
		$MarginContainer/ColorRect/NameNode.visible = false
		$MarginContainer/ColorRect/TextNode/TextLabel.text = current_script_entry['text']

func read_conversation_line():
		$LeftPortrait.visible = true
		$RightPortrait.visible = true
		$MarginContainer/ColorRect/NameNode.visible = true
		$MarginContainer/ColorRect/NameNode/NameLabel.text = current_script_entry['name']
		$MarginContainer/ColorRect/TextNode/TextLabel.text = current_script_entry['text']
		
		var active_portrait = current_script_entry['active_portrait']
		if (active_portrait == 'left'):
			$LeftPortrait.modulate.a = 1
			$RightPortrait.modulate.a = 0.5
			
		if (active_portrait == 'right'):
			$LeftPortrait.modulate.a = 0.5
			$RightPortrait.modulate.a = 1

func read_choice_line():
	play_open_box_animation(true)
	yield(_anim_player, "animation_finished")
	$ChoiceContainer/FirstChoiceButton.texture_normal = load(current_script_entry.left_choice.resource)
	$ChoiceContainer/SecondChoiceButton.texture_normal = load(current_script_entry.right_choice.resource)
	$ChoiceContainer.visible = true

func play_open_box_animation(open):
	if (open):
		_anim_player.play("open_box")
	else:
		_anim_player.play_backwards("open_box")

func _on_FirstChoiceButton_pressed():
	assert (current_script_entry && current_script_entry.left_choice)
	act_on_choice(current_script_entry.left_choice)

func _on_SecondChoiceButton_pressed():
	assert (current_script_entry && current_script_entry.right_choice)
	act_on_choice(current_script_entry.right_choice)
		
func act_on_choice(choice):
	$ChoiceContainer.visible = false
	if (choice.next_choice_index):
		next_script_index = choice.next_choice_index
		play_open_box_animation(false)
		yield(_anim_player, "animation_finished")
		toggle_choice_mode(false)
		next_line()
		

