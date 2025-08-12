extends State

func enter() -> void:
	print("[State] -> Interacting")
	super()

func process_frame(_delta: float) -> State:
	parent.start_interact = true
	parent.ui.interact_key.visible = false
	
	return parent.idleState
