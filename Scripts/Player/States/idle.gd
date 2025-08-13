extends State

func enter() -> void:
	print("[State] -> Idle")
	super()

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("move_right") || event.is_action_pressed("move_left"):
			if parent.walkingAbility:
				return parent.walkingState
			
			elif parent.runningAbility && !parent.walkingAbility:
				return parent.runningState
		
		
		if event.is_action_pressed("jump") && parent.jumpingAbility:
			return parent.startJumpingState
		
		if event.is_action_pressed("dash") && parent.dashingAbility && parent.runtime_vars.dash_points > 0:
			return parent.dashingState
		
		if event.is_action_pressed("attack") && parent.attackingAbility:
			return parent.attackingState
		
		if event.is_action_pressed("shoot") && parent.shootingAbility:
			return parent.shootingState
		
		if event.is_action_pressed("reload") && parent.ammoInMag < parent.maxAmmo:
			return parent.reloadingState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		parent.runtime_vars.damaged = false
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
	if parent.runtime_vars.npc_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.talkingState
	
	elif parent.runtime_vars.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.interactState
	
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(_delta: float) -> State:
	if !parent.is_on_floor():
		return parent.fallingState
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.runtime_vars.movement_weight)
	
	if !jump_buffer_timer.is_stopped():
		return parent.startJumpingState
	
	parent.move_and_slide()
	
	return null
