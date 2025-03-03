extends State

@export var idleState: State
@export var walkingState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

@export var acceleration: int = 20

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(jumpingInput) && parent.is_on_floor():
		return startJumpingState
	
	if Input.is_action_just_pressed(attackingInput) && parent.is_on_floor():
		return attackingState
	
	if Input.is_action_just_pressed(shootingInput) && parent.is_on_floor():
		return shootingState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * runSpeed
	
	if !movement:
		return idleState
	
	#parent.player_sprite.flip_h = movement > 0
	
	if movement > 0:
		parent.player_sprite.scale.x = 1
	else:
		parent.player_sprite.scale.x = -1
	
	if movement >= runSpeed:
		parent.velocity.x = min(parent.velocity.x + acceleration, movement)
	else:
		parent.velocity.x = max(parent.velocity.x - acceleration, movement)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		coyote_timer.start()
		return fallingState
	
	return null
