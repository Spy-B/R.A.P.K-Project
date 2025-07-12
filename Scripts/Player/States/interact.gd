extends State

@export var idleState: State

func enter() -> void:
	#print("Im interacting")
	pass

func process_frame(_delta: float) -> State:
	parent.start_interact = true
	parent.ui.interact_key.visible = false
	
	return idleState
