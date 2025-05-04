extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var landingState: State
@export var attackingState: State
@export var shootingState: State
@export var talkingState: State
@export var deathState: State

var attack_type: Array = []

func enter() -> void:
	super()
	
	attack_type.clear()
	parent.a_n_s_p = false

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(jumpingInput):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()
		
		if !coyote_timer.is_stopped() && parent.have_coyote:
			parent.have_coyote = false
			return startJumpingState
	
	if Input.is_action_just_pressed(attackingInput):
		parent.a_n_s_p = true
		attack_type.append(1)
	elif Input.is_action_just_pressed(shootingInput):
		parent.a_n_s_p = true
		attack_type.append(2)
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * runSpeed
	
	if movement != 0  && !parent.is_on_floor():
		if movement > 0:
			parent.player_sprite.scale.x = 1
		else:
			parent.player_sprite.scale.x = -1
			
	parent.velocity.x = lerp(parent.velocity.x, movement, parent.movementWeight)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.a_n_s_p && attack_type.has(1):
			return attackingState
		if parent.a_n_s_p && attack_type.has(2):
			return shootingState
		
		return landingState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.can_start_dialogue:
		parent.interact_key.visible = true
		
		if Input.is_action_just_pressed("interact"):
			return talkingState
	else:
		parent.interact_key.visible = false
	
	return null
