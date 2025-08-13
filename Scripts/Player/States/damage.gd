extends State

func enter() -> void:
	print("[State] -> Damaging")
	super()
	
	parent.runtime_vars.damaged = false

func process_frame(_delta: float) -> State:
	if !parent.runtime_vars.just_respawn:
		parent.health_bar_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		parent.health_bar_tween.tween_property(parent.ui.health_bar, "value", parent.health, 0.05)
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if parent.is_on_floor():
		if movement:
			return parent.runningState
		else:
			return parent.idleState
	else:
		return parent.fallingState
	
	#return null
