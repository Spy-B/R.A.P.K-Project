extends Control

@onready var label: Label = $Label
@onready var ez_dialogue: EzDialogue = $EzDialogue
@onready var timer: Timer = $Timer


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	Next()

func clear_dialogue_box() -> void:
	label.text = ""

func add_text(text: String) -> void:
	label.text = text

func Next() -> void:
	if Input.is_action_just_pressed("continue"):
		timer.wait_time = 5
		(ez_dialogue as EzDialogue).next()

func _on_timer_timeout() -> void:
	if Global.inConversation:
		(ez_dialogue as EzDialogue).next()
