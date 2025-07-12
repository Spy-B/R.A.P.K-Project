extends State

@export var idleState: State
@export var runningState: State
@export var fallingState: State
@export var damagingState: State

@export_range(500, 5000, 100) var dashPower: float = 2500
@export_range(100, 1000, 50) var dashLength: float = 250
var z: Vector2

@onready var dash_cooldown: Timer = $"../../Timers/DashCooldown"

func enter() -> void:
	parent.velocity = Vector2.ZERO
	
	if parent.dash_points > 0:
		#super()
		
		if !parent.dash_dir:
			parent.dash_dir = Input.get_action_strength("move_right") * Vector2.RIGHT
			parent.dash_dir += Input.get_action_strength("move_left") * Vector2.LEFT
			#parent.dash_dir += Input.get_action_strength("move_up") * Vector2.UP
			#parent.dash_dir += Input.get_action_strength("move_down") * Vector2.DOWN
		
		parent.dash_points -= 1
		
		dash_cooldown.wait_time = 1.0
		dash_cooldown.start()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	z += parent.velocity * delta
	
	if z.x <= dashLength && parent.dash_dir == Vector2.RIGHT:
		parent.velocity = parent.dash_dir * dashPower
	
	elif z.x >= -dashLength && parent.dash_dir == Vector2.LEFT:
		parent.velocity = parent.dash_dir * dashPower
	
	else:
		z = Vector2.ZERO
		parent.velocity = Vector2.ZERO
		#parent.dash_dir = Vector2.ZERO
		
		if !parent.is_on_floor():
			return fallingState
		
		var movement: float = Input.get_axis("move_left", "move_right") * runSpeed
		if movement:
			return runningState
		
		return idleState
	
	if parent.is_on_wall():
		return fallingState
	
	parent.move_and_slide()
	
	return null
