extends State

@onready var hit_area_collision: CollisionShape2D = $"../../PlayerSprite/HitArea/CollisionShape2D"
@onready var respawn_cooldown: Timer = $"../../Timers/RespawnCooldown"

func enter() -> void:
	print("[State] -> Respawning")
	super()
	
	parent.just_respawn = true
	parent.respawning_effect()
	respawn_cooldown.start()
	
	parent.collision_shape.disabled = false
	parent.modulate = Color.WHITE
	
	parent.global_position = parent.checkpointManager.last_position
	
	parent.health_bar_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	parent.health_bar_tween.tween_property(parent.ui.health_bar, "value", 100, 1.5)

func process_frame(_delta: float) -> State:
	parent.health = 100
	hit_area_collision.disabled = true
	
	return parent.idleState
