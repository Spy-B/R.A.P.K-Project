extends NPCsState

@export var idleState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var damagingState: NPCsState
@export var deathState: NPCsState

@export_group("Movement")
#@export var 

var waiting_time: float
var change_state: bool = false

func enter() -> void:
	super()
	#print("[Enemy][State]: Wander")
	parent.status_history.append(self)
	
	change_state = false
	
	randomize()
	waiting_time = randf_range(1, 4)
	
	rgs_timer.wait_time = waiting_time
	rgs_timer.start()
	
	dir *= -1

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = walkSpeed * dir
	sprite.scale.x = abs(sprite.scale.x) * dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return damagingState
	
	if change_state:
		return idleState
	
	if !parent.g_ray_cast.is_colliding():
		return idleState
	
	if parent.w_ray_cast.is_colliding():
		dir *= -1
	
	if parent.player_detected:
		return chasingState
		
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
