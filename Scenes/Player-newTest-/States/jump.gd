extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var fallingState: State
@export var landingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

@export var jumpPower: int = 300
@export var jumpingWeight: float = 0.1



func enter() -> void:
	super()
	
	parent.velocity.y = -jumpPower

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fallingState
	
	var movement = Input.get_axis("move_left", "move_right") * runSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
		else:
			parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> State:
	if parent.health <= 0:
		return deathState
	
	return null
