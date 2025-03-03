extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var deathState: NPCsState

func enter() -> void:
	super()
	
	print("[Enemy][State]: Shoot")

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	return null
