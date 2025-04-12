extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var deathState: NPCsState

@export var dialogueJson: JSON
@onready var state: Dictionary = {}

@onready var dialogue_box: Control = $"../../UI/DialogueBox"
@onready var ez_dialogue: EzDialogue = $"../../UI/DialogueBox/EzDialogue"

func enter() -> void:
	super()
	print("[Enemy][State]: Talk")
	
	(ez_dialogue as EzDialogue).start_dialogue(dialogueJson, state)

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	return null


func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	dialogue_box.add_text(response.text)


func _on_ez_dialogue_end_of_dialogue_reached() -> void:
	if !dialogue_box.dialogue_text.text:
		parent.player.is_in_dialogue = false
