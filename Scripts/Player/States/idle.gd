extends State

@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var reloadingState: State
@export var talkingState: State
@export var deathState: State

func enter() -> void:
	super()
	#parent.velocity.x = lerp(parent.velocity.x, 0.0, movementWeight)

func process_input(_event: InputEvent) -> State:
	if parent.is_on_floor():
		if Input.is_action_just_pressed(jumpingInput):
			return startJumpingState
		
		if Input.is_action_just_pressed(attackingInput):
			return attackingState
		
		if Input.is_action_just_pressed(shootingInput):
			return shootingState
		
		if Input.is_action_just_pressed("reload"):
			return reloadingState
	
	
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		return runningState
	
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
		return fallingState
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	if !jump_buffer_timer.is_stopped():
		return startJumpingState
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> State:
	if parent.health <= 0:
		return deathState
	
	if parent.can_start_dialogue:
		parent.interact_key.visible = true
		
		if Input.is_action_just_pressed("interact"):
			return talkingState
	else:
		parent.interact_key.visible = false
	
	return null
