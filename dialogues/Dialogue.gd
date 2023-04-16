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
	$MarginContainer/ColorRect/ColorRect/NameLabel.text = dialogue_entry['name']
	$MarginContainer/ColorRect/ColorRect/TextLabel.text = dialogue_entry['text']
	
	var active_portrait = dialogue_entry['active_portrait']
	if (dialogue_entry['active_portrait'] == 'left'):
		$LeftPortrait.modulate.a = 1
		$RightPortrait.modulate.a = 0.5
		
	if (dialogue_entry['active_portrait'] == 'right'):
		$LeftPortrait.modulate.a = 0.5
		$RightPortrait.modulate.a = 1
