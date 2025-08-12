extends State

var attack_type: Array = []

func enter() -> void:
	print("[State] -> Falling")
	super()
	
	attack_type.clear()
	parent.a_n_s_p = false

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") && parent.jumpingAbility:
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
		
		if !coyote_timer.is_stopped() && parent.have_coyote:
			parent.have_coyote = false
			return parent.startJumpingState
	
	
	if event.is_action_pressed("dash") && parent.dash_points > 0:
		return parent.dashingState
	
	
	if event.is_action_pressed("attack"):
		parent.a_n_s_p = true
		attack_type.append(1)
	
	elif event.is_action_pressed("shoot"):
		parent.a_n_s_p = true
		attack_type.append(2)
	
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return parent.damagingState
	
	if parent.npc_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.talkingState
	
	elif parent.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.interactState
	
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.falling_gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if movement != 0  && !parent.is_on_floor():
		if movement > 0:
			parent.player_sprite.scale.x = 1
			parent.dash_dir = Vector2.RIGHT
		else:
			parent.player_sprite.scale.x = -1
			parent.dash_dir = Vector2.LEFT
	
	parent.velocity.x = lerp(parent.velocity.x, movement, parent.movementWeight)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.a_n_s_p && attack_type.has(1):
			return parent.attackingState
		if parent.a_n_s_p && attack_type.has(2):
			return parent.shootingState
		
		return parent.landingState
	
	return null
