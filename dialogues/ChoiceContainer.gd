extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_FirstChoiceButton_mouse_entered():
	$FirstChoiceButton.rect_scale = Vector2(1.05,1.05)

func _on_FirstChoiceButton_mouse_exited():
	$FirstChoiceButton.rect_scale = Vector2(1,1)

func _on_SecondChoiceButton_mouse_entered():
	$SecondChoiceButton.rect_scale = Vector2(1.05,1.05)

func _on_SecondChoiceButton_mouse_exited():
	$SecondChoiceButton.rect_scale = Vector2(1,1)

