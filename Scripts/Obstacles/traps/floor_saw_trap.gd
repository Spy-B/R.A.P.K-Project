extends CharacterBody2D

@export var trapAnimation: String
@export var trapSpeed: float = 150

@export_group("Target")
@export var player: CharacterBody2D
@export var damage: float

@export_group("Camera Shake")
@export var shakeAmount: Vector2 = Vector2.ZERO
@export var shakeTime: float = 0.1

var dir: int = 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var trap_ray_cast: RayCast2D = $TrapRayCast

func _ready() -> void:
	animation_player.play(trapAnimation)

func _process(_delta: float) -> void:
	velocity.x = trapSpeed * dir
	
	if trap_ray_cast.is_colliding():
		dir *= -1
		trap_ray_cast.target_position = trap_ray_cast.target_position * -1
	
	move_and_slide()

func _player_enterd_the_trap(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.camera.shake(shakeTime, shakeAmount)
