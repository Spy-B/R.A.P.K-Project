extends State

var z: Vector2

@onready var dash_cooldown: Timer = $"../../Timers/DashCooldown"

func enter() -> void:
	print("[State] -> Dashing")
	
	parent.velocity = Vector2.ZERO
	
	if parent.runtime_vars.dash_points > 0:
		super()
		
		if !parent.dash_dir:
			parent.dash_dir = Input.get_action_strength("move_right") * Vector2.RIGHT
			parent.dash_dir += Input.get_action_strength("move_left") * Vector2.LEFT
			#parent.dash_dir += Input.get_action_strength("move_up") * Vector2.UP
			#parent.dash_dir += Input.get_action_strength("move_down") * Vector2.DOWN
		
		parent.runtime_vars.dash_points -= 1
		
		dash_cooldown.wait_time = 1.0
		dash_cooldown.start()

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	z += parent.velocity * delta
	
	
	if z.x <= parent.dashLength && parent.dash_dir == Vector2.RIGHT:
		parent.velocity = parent.dash_dir * parent.dashPower
	
	elif z.x >= -parent.dashLength && parent.dash_dir == Vector2.LEFT:
		parent.velocity = parent.dash_dir * parent.dashPower
	
	else:
		z = Vector2.ZERO
		parent.velocity = Vector2.ZERO
		#parent.dash_dir = Vector2.ZERO
		
		var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
		
		if parent.is_on_floor():
			if movement:
				return parent.runningState
		
			return parent.idleState
		
		else:
			return parent.fallingState
	
	
	if parent.is_on_wall():
		return parent.fallingState
	
	parent.move_and_slide()
	
	return null
