extends State

@export var idleState: State
@export var respawningState: State

func enter() -> void:
	super()

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		return respawningState
	
	return null
