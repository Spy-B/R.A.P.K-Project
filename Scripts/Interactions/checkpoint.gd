extends Area2D

@export var checkpoint_manager: Node
@export var playerGroup: String
@export var light := false

@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	if light:
		$PointLight2D.enabled = true
	else:
		$PointLight2D.enabled = false

func _on_body_entered(body):
	if body.is_in_group(playerGroup):
		checkpoint_manager.last_position = $RespawnPoint.global_position
		set_deferred("monitoring", false)
