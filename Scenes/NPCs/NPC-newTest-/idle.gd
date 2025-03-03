extends NPCsState

@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var deathState: NPCsState

var waiting_time: float
var change_state: bool = false

func enter() -> void:
	super()
	print("[Enemy][State]: Idle")
	
	change_state = false
	
	randomize()
	waiting_time = randf_range(1, 3)
	print("Waiting Time: ", waiting_time)
	
	rgs_timer.wait_time = waiting_time
	rgs_timer.start()

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.health <= 0:
		return deathState
	
	if change_state:
		return wanderingState
	
	if !parent.g_ray_cast.is_colliding():
		return wanderingState
	if parent.w_ray_cast.is_colliding():
		dir *= -1
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
