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
	
	if parent.NpcType == 0:
		randomize()
		waiting_time = randf_range(1, 3)
		
		rgs_timer.wait_time = waiting_time
		rgs_timer.start()
	else:
		return

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
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
	
	if parent.player_detected:
		return chasingState
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
