extends Control

@export var waitingTime: int = 5

@onready var dialogue_text: Label = $DialogueText
@onready var ez_dialogue: EzDialogue = $EzDialogue
@onready var dialogue_timer: Timer = $DialogueTimer

func _ready() -> void:
	clear_dialogue_box()

func _physics_process(_delta: float) -> void:
	next()

func clear_dialogue_box() -> void:
	dialogue_text.text = ""

func add_text(text: String) -> void:
	dialogue_text.text = text

func next() -> void:
	if Input.is_action_just_pressed("continue"):
		dialogue_timer.wait_time = waitingTime
		(ez_dialogue as EzDialogue).next()

func _on_dialogue_timer_timeout() -> void:
	#if Global.inConversation:
	(ez_dialogue as EzDialogue).next()
