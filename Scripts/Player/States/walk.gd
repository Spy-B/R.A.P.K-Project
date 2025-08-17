extends State

func enter() -> void:
	print("[State] -> Walking")
	super()

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("jump") && parent.jumpingAbility:
			return parent.startJumpingState
	
		if event.is_action_pressed("dash") && parent.dashingAbility:
			if parent.runtime_vars.dash_points > 0:
				return parent.dashingState
	
		if event.is_action_pressed("shoot") && parent.shootingAbility:
			return parent.shootingState
	
	return null

func process_frame(_delta: float) -> State:
	if Input.is_action_pressed("run") && parent.runningAbility:
		return parent.runningState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.walkSpeed
	
	if !movement:
		return parent.idleState
	
	if movement > 0:
		parent.player_sprite.scale.x = 1
		parent.dash_dir = Vector2.RIGHT
	elif movement < 0:
		parent.player_sprite.scale.x = -1
		parent.dash_dir = Vector2.LEFT
	
	if movement >= parent.runSpeed:
		parent.velocity.x = min(parent.velocity.x + parent.acceleration, movement)
	else:
		parent.velocity.x = max(parent.velocity.x - parent.acceleration, movement)
	
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor() && movement != 0:
		return parent.fallingState
	
	return null
