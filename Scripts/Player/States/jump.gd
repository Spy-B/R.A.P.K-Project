extends State

func enter() -> void:
	print("[State] -> Jumping")
	super()
	
	parent.runtime_vars.jump_points -= 1
	parent.velocity.y = -parent.jumpPower

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points > 0:
		return parent.jumpingState
	
	if event.is_action_pressed("dash") && parent.dashingAbility:
		if parent.runtime_vars.dash_points > 0:
			return parent.dashingState
	
	return null

func process_frame(_delta: float) -> State:
	if !Input.is_action_pressed("jump") && parent.velocity.y < 0:
		parent.velocity.y = lerp(parent.velocity.y, 0.0, parent.jumpWeight)
	
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
	if parent.runtime_vars.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.talkingState
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	if parent.velocity.y > 0:
		return parent.fallingState
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
			parent.dash_dir = Vector2.RIGHT
		else:
			parent.player_sprite.scale.x = -1
			parent.dash_dir = Vector2.LEFT
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	return null
