extends State

@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

func enter() -> void:
	super()
	#parent.velocity.x = lerp(parent.velocity.x, 0.0, movementWeight)

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(jumpingInput) && parent.is_on_floor():
		return startJumpingState
	
	if Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left"):
		return runningState
	
	if Input.is_action_just_pressed(attackingInput) && parent.is_on_floor():
		return attackingState
	
	if Input.is_action_just_pressed(shootingInput) && parent.is_on_floor():
		return shootingState
	
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
	
	return null
