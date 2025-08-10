extends State

@export var idleState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var damagingState: State
@export var deathState: State

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") && parent.jumpingAbility:
		return startJumpingState
	
	return null

func process_frame(_delta: float) -> State:
	if Input.is_action_pressed("run") && parent.runningAbility:
		return runningState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.walkSpeed
	
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
