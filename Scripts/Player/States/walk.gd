extends State

@export var idleState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

func process_input(_event: InputEvent) -> State:
	#if Input.is_action_pressed(runningInput):
		#return runningState
	
	if Input.is_action_just_pressed(jumpingInput):
		return startJumpingState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * walkSpeed
	
	if !movement:
		return idleState
	
	if movement > 0:
		parent.player_sprite.scale.x = 1
	else:
		parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !parent.is_on_floor() && movement != 0:
		return fallingState
	
	return null
