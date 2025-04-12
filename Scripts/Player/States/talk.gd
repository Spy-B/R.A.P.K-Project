extends State

@export var idleState: State
#@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var reloadingState: State
@export var deathState: State

func enter() -> void:
	parent.is_in_dialogue = true

func process_input(_input: InputEvent) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null

func process_frame(_delta: float) -> State:
	if !parent.is_in_dialogue:
		return idleState
	
	return null
