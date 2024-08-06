extends Control

@onready var label = $Label
@onready var ez_dialogue = $EzDialogue
@onready var timer = $Timer

@warning_ignore("unused_parameter")
func _physics_process(delta):
	Next()

func clear_dialogue_box():
	label.text = ""

func add_text(text: String):
	label.text = text

func Next():
	if Input.is_action_just_pressed("continue"):
		timer.wait_time = 5
		(ez_dialogue as EzDialogue).next()

func _on_timer_timeout():
	if Global.inConversation:
		(ez_dialogue as EzDialogue).next()


func _on_ez_dialogue_dialogue_generated(response):
	pass # Replace with function body.
