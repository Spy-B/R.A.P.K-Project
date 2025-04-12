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
	
	match parent.NpcType:
		0:
			randomize()
			waiting_time = randf_range(1, 3)
			
			rgs_timer.wait_time = waiting_time
			rgs_timer.start()
		1:
			parent.set_collision_layer_value(17, false)
			parent.set_collision_layer_value(23, true)
			
			parent.g_ray_cast.enabled = false
			parent.w_ray_cast.enabled = false
			parent.shoot_ray_cast.enabled = false
			#parent.player_detector.enabled = false
			
			parent.player_detector.target_position.x = 25.0

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	var player_pos = (parent.player.global_position - parent.global_position).normalized()
	
	if player_pos > Vector2(0, 0):
		dir = 1
	elif player_pos < Vector2(0, 0):
		dir = -1
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	sprite.scale.x = abs(sprite.scale.x) * dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	match parent.NpcType:
		0:
			if parent.health <= 0:
				return deathState
			
			if !parent.g_ray_cast.is_colliding() || change_state:
				return wanderingState
			
			if parent.w_ray_cast.is_colliding():
				dir *= -1
			
			if parent.player_detected:
				return chasingState
		1:
			#dir = -1
			pass
	
	if Input.is_action_just_pressed("interact"):
		return talkingState
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
