extends CanvasLayer

export(String, FILE, "*.json") var dialogue_file

var dialogue = null
var current_dialogue_id = 0
	
func play():
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
	next_line()

func next_line():
	current_dialogue_id += 1
	
	if (current_dialogue_id >= len(dialogue.entries)):
		return
		
	read_line()

func read_line():
	var dialogue_entry = dialogue.entries[current_dialogue_id]
	
	if (dialogue_entry.mode == 'narration'):
		read_narration_line(dialogue_entry)
	
	if (dialogue_entry.mode == 'conversation'):
		read_conversation_line(dialogue_entry)
	

func read_narration_line(entry):
		$LeftPortrait.visible = false
		$RightPortrait.visible = false
		$MarginContainer/ColorRect/ColorRect/NameLabel.visible = false
		$MarginContainer/ColorRect/ColorRect/TextLabel.text = entry['text']

func read_conversation_line(entry):
		$LeftPortrait.visible = true
		$RightPortrait.visible = true
		$MarginContainer/ColorRect/ColorRect/NameLabel.visible = true
		$MarginContainer/ColorRect/ColorRect/NameLabel.text = entry['name']
		$MarginContainer/ColorRect/ColorRect/TextLabel.text = entry['text']
		
		var active_portrait = entry['active_portrait']
		if (active_portrait == 'left'):
			$LeftPortrait.modulate.a = 1
			$RightPortrait.modulate.a = 0.5
			
		if (active_portrait == 'right'):
			$LeftPortrait.modulate.a = 0.5
			$RightPortrait.modulate.a = 1
