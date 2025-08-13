extends State

@export_group("Timer")
@onready var timer: Timer = $"../../Timers/StartJumpTimer"
@export var wait_time: float = 1

var timeout: bool = false

func enter() -> void:
	print("[State] -> Start Jumping")
	super()
	
	timeout = false
	timer.wait_time = wait_time
	timer.start()

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	return null

func process_physics(_delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * parent.walkSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
			parent.dash_dir = Vector2.RIGHT
		else:
			parent.player_sprite.scale.x = -1
			parent.dash_dir = Vector2.LEFT
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if timeout:
		return parent.jumpingState
	
	return null

func _on_start_jump_timer_timeout() -> void:
	timeout = true
