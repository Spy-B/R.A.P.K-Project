@tool
extends Path2D

@export var loop: bool = true
var speed: float = 1.0
@export var speedScale: float = 1.0

@export_group("Properties")
@export var texture: Texture
@export var animatedTexture: SpriteFrames
@export var animeName: StringName = "default"

@export var textureScale: float = 1.0

@export var collisionShape: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export var damage: int = 25


@onready var path_follower: PathFollow2D = $PathFollow2D
@onready var collision_shape: CollisionShape2D = $Obstacle/CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $Obstacle/AnimatedSprite2D
@onready var sprite: Sprite2D = $Obstacle/ObstacleSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if loop && curve != null:
		animation_player.play("Moving")
		set_physics_process(false)
	
	apply_properties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

func _physics_process(_delta: float) -> void:
	path_follower.progress += speed


func apply_properties() -> void:
	if animatedTexture:
		animated_sprite.sprite_frames = animatedTexture
	
		if !animated_sprite.is_playing():
			animated_sprite.play(animeName)
	
	elif sprite:
		sprite.texture = texture
	
	
		sprite.scale.x = textureScale
		sprite.scale.y = textureScale
		animated_sprite.scale.x = textureScale
		animated_sprite.scale.y = textureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	animation_player.speed_scale = speedScale


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.runtime_vars.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
