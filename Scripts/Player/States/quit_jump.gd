extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

@export_group("Timer")
@onready var timer: Timer = $"../../Timers/LandTimer"
@export var wait_time: float = 1

var timeout = false

func enter() -> void:
	super()
	
	parent.have_coyote = true
	
	timeout = false
	timer.wait_time = wait_time
	timer.start()

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(jumpingInput):
		return startJumpingState
	
	return null

func process_physics(_delta: float) -> State:
	var movement = Input.get_axis("move_left", "move_right") * walkSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
		else:
			parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !jump_buffer_timer.is_stopped():
		return startJumpingState
	
	if timeout:
		if !movement && parent.is_on_floor():
			return idleState
		return runningState
	
	return null

func _on_quit_jump_timer_timeout() -> void:
	timeout = true
