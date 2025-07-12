extends Control

@export_range(0.0, 10.0, 0.5) var waitingTime: float = 5.0

@onready var dialogue_text: Label = $DialogueText
@onready var ez_dialogue: EzDialogue = $EzDialogue
@onready var dialogue_timer: Timer = $DialogueTimer
@onready var dialogue_timer_progress: TextureProgressBar = $DialogueTimerProgress
@onready var parent: CharacterBody2D = $"../.."

func _ready() -> void:
	clear_dialogue_box()
	
	dialogue_timer.wait_time = waitingTime

func _process(_delta: float) -> void:
	next()

func clear_dialogue_box() -> void:
	dialogue_text.text = ""
	
func add_text(text: String) -> void:
	dialogue_text.text = text
	dialogue_timeout_anime()
	
	if parent.player.is_in_dialogue:
		dialogue_timer.start()
	
	if text == "":
		dialogue_timer_progress.visible = false
		(ez_dialogue as EzDialogue).next()

func next() -> void:
	if Input.is_action_just_pressed("interact"):
		dialogue_timer.wait_time = waitingTime
		(ez_dialogue as EzDialogue).next()

func _on_dialogue_timer_timeout() -> void:
	(ez_dialogue as EzDialogue).next()

func dialogue_timeout_anime() -> void:
	var tween: Tween = get_tree().create_tween()
	
	dialogue_timer_progress.value = 100.0
	dialogue_timer_progress.visible = true
	
	tween.tween_property(dialogue_timer_progress, "value", 0.0, waitingTime).from(100.0).set_ease(Tween.EASE_IN_OUT)
