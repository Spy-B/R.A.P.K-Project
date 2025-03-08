extends State

@export var idleState: State

func enter() -> void:
	super()
	
	parent.collision_shape.disabled = false
	parent.modulate = Color.WHITE
	
	parent.global_position = parent.checkpointManager.last_position

func process_frame(_delta: float) -> State:
	parent.health = 100
	parent.health_label.text = str(parent.health)
	
	return idleState
