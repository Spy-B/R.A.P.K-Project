extends Control

@onready var label = $Label
@onready var ez_dialogue = $EzDialogue

@warning_ignore("unused_parameter")
func _physics_process(delta):
	Next()

func clear_dialogue_box():
	label.text = ""

func add_text(text: String):
	label.text = text

func Next():
	if Input.is_action_just_pressed("continue"):
		(ez_dialogue as EzDialogue).next()
