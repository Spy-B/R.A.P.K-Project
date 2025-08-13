extends NPCsState

@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var damagingState: NPCsState
@export var deathState: NPCsState

var change_state: bool = false

func enter() -> void:
	super()
	#print("[Enemy][State]: Idle")
	parent.status_history.append(self)
	
	change_state = false

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	sprite.scale.x = abs(sprite.scale.x) * dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	match parent.NpcType:
		0:
			if parent.damaged:
				return damagingState
			
			if !parent.g_ray_cast.is_colliding() || change_state:
				return wanderingState
			
			if parent.w_ray_cast.is_colliding():
				dir *= -1
			
			if parent.player_detected:
				return chasingState
		1:
			parent.player_pos = (parent.player.global_position - parent.global_position).normalized()
			
			if parent.player_pos > Vector2(0, 0):
				dir = 1
			elif parent.player_pos < Vector2(0, 0):
				dir = -1
			
			if parent.player.runtime_vars.start_dialogue:
				return talkingState
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
