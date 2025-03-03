extends State

@export var walkingState: State
@export var runningState: State
@export var jumpingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

@export_group("Timer")
@onready var timer: Timer = $StartJumpTimer
@export var wait_time: float = 1

var timeout = false

func enter() -> void:
	super()
	
	timeout = false
	timer.wait_time = wait_time
	timer.start()

func process_physics(_delta: float) -> State:
	var movement = Input.get_axis("move_left", "move_right") * walkSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
		else:
			parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if timeout:
		return jumpingState
	
	return null

func _on_start_jump_timer_timeout() -> void:
	timeout = true
