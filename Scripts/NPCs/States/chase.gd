extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var cooldownState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var deathState: NPCsState

@export_range(0, 10, 0.5) var cooldownPeriod: float = 5.0
@onready var cooldown_period_timer: Timer = $"../../Timers/CooldownPeriodTimer"


func enter() -> void:
	super()
	print("[Enemy][State]: Chase")
	
	cooldown_period_timer.wait_time = cooldownPeriod
	
	parent.player_detector.target_position.x = 300.0

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	var player_pos = (parent.player.global_position - parent.global_position).normalized()
	
	if player_pos > Vector2(0, 0):
		dir = 1
	elif player_pos < Vector2(0, 0):
		dir = -1
	
	parent.velocity.x = walkSpeed * dir
	sprite.scale.x = abs(sprite.scale.x) * dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.health <= 0:
		return deathState
	
	if parent.shoot_ray_cast.get_collider() == parent.player:
		return shootingState
	
	if !parent.player_detected: 
		return cooldownState
	
	return null
