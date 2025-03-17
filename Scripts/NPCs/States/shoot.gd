extends NPCsState

@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var deathState: NPCsState

@export var bulletScene: PackedScene
@export_range(0, 1, 0.02) var fireRate: float = 0.5

@onready var shooting_timer: Timer = $"../../Timers/ShootingTimer"

func enter() -> void:
	super()
	print("[Enemy][State]: Shoot")
	
	shooting_timer.wait_time = fireRate
	shooting_timer.start()

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
	
	if !parent.shoot_ray_cast.get_collider() == parent.player:
		return idleState
	
	return null


func _on_shooting_timer_timeout() -> void:
	if parent.shoot_ray_cast.get_collider() == parent.player:
		var bullet = bulletScene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		bullet.global_position = gun_barrel.global_position
		bullet.global_rotation = gun_barrel.global_rotation
		bullet.dir = dir
		get_parent().add_child(bullet)
		
		enter()
		#shooting_timer.stop()
