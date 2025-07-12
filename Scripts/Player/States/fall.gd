extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var landingState: State
@export var dashingState: State
@export var attackingState: State
@export var shootingState: State
@export var interactState: State
@export var talkingState: State
@export var damagingState: State
@export var deathState: State

var attack_type: Array = []

func enter() -> void:
	super()
	
	attack_type.clear()
	parent.a_n_s_p = false

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(jumpingInput):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
		
		if !coyote_timer.is_stopped() && parent.have_coyote:
			parent.have_coyote = false
			return startJumpingState
	
	
	if event.is_action_pressed("dash") && parent.dash_points > 0:
		return dashingState
	
	
	if event.is_action_pressed(attackingInput):
		parent.a_n_s_p = true
		attack_type.append(1)
	
	elif event.is_action_pressed(shootingInput):
		parent.a_n_s_p = true
		attack_type.append(2)
	
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	if parent.npc_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return talkingState
	
	elif parent.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return interactState
	
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += falling_gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * runSpeed
	
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
			return attackingState
		if parent.a_n_s_p && attack_type.has(2):
			return shootingState
		
		return landingState
	
	return null
