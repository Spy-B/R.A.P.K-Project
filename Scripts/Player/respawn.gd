extends State

@export var idleState: State

@onready var hit_area_collision: CollisionShape2D = $"../../PlayerSprite/HitArea/CollisionShape2D"
@onready var respawn_cooldown: Timer = $"../../Timers/RespawnCooldown"

func enter() -> void:
	super()
	parent.just_respawn = true
	parent.respawning_effect()
	respawn_cooldown.start()
	
	parent.collision_shape.disabled = false
	parent.modulate = Color.WHITE
	
	parent.global_position = parent.checkpointManager.last_position

func process_frame(_delta: float) -> State:
	parent.health = 100
	hit_area_collision.disabled = true
	
	return idleState
