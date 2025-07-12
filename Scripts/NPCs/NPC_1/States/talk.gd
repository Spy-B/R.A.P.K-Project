extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var deathState: NPCsState

@onready var dialogue_box: Control = $"../../UI/DialogueBox"
@onready var ez_dialogue: EzDialogue = $"../../UI/DialogueBox/EzDialogue"

func enter() -> void:
	super()
	animation.speed_scale = 0.5
	#print("[Enemy][State]: Talk")
	
	parent.player.is_in_dialogue = true
	parent.player.npc_you_talk_to = parent
	
	(ez_dialogue as EzDialogue).start_dialogue(parent.dialogueJson, parent.state)

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if !parent.player.is_in_dialogue:
		return idleState
	
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.move_and_slide()
	
	return null

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	dialogue_box.add_text(response.text)

func _on_ez_dialogue_end_of_dialogue_reached() -> void:
	if !dialogue_box.dialogue_text.text:
		parent.player.is_in_dialogue = false
		parent.player.start_dialogue = false

func exit() -> void:
	animation.speed_scale = 1.0
