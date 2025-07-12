@tool
extends Node2D
class_name SwingingPendulum

var tween: Tween

@export_group("Stick Preperties")
@export var stickTexture: Texture
@export var stickTextureScale: float = 1.0
@export var rotated: bool = false

@export_group("Pendulum Preperties")
@export var pendulumTexture: Texture
@export var animatedPendulumSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var pendulumScale: float = 1.0
@export var collisionShape: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export var damage: int = 25
@export var swingTime: float = 1.0

@onready var swinging_ceneter: Marker2D = $SwingingCeneter
@onready var stick_sprite: Sprite2D = $SwingingCeneter/StickSprite
@onready var pendulum: Area2D = $SwingingCeneter/Pendulum
@onready var pendulum_sprite: Sprite2D = $SwingingCeneter/Pendulum/PendulumSprite
@onready var animated_pendulum_sprite: AnimatedSprite2D = $SwingingCeneter/Pendulum/AnimatedPendulumSprite
@onready var collision_shape: CollisionShape2D = $SwingingCeneter/Pendulum/CollisionShape2D

func _ready() -> void:
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_loops()
	tween.tween_property(swinging_ceneter, "rotation_degrees", -75.0, swingTime).from(75.0)
	tween.tween_property(swinging_ceneter, "rotation_degrees", 75.0, swingTime).from(-75.0)
	
	apply_preperties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_preperties()

func _physics_process(_delta: float) -> void:
	pass


func apply_preperties() -> void:
	if stickTexture:
		stick_sprite.texture = stickTexture
		stick_sprite.scale.x = stickTextureScale
		stick_sprite.scale.y = stickTextureScale
		
		if rotated:
			stick_sprite.rotation_degrees = 90.0
		else:
			stick_sprite.rotation_degrees = 0.0
		
		stick_sprite.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	if pendulumTexture:
		pendulum_sprite.texture = pendulumTexture
		pendulum_sprite.scale.x = pendulumScale
		pendulum_sprite.scale.y = pendulumScale
		
		pendulum.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y)
	
	if animatedPendulumSprite && !animated_pendulum_sprite.is_playing():
		animated_pendulum_sprite.sprite_frames = animatedPendulumSprite
		animated_pendulum_sprite.scale.x = pendulumScale
		animated_pendulum_sprite.scale.y = pendulumScale
		
		animated_pendulum_sprite.play(animeName)
		
		pendulum.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y)
	
	if collisionShape:
		collision_shape.shape = collisionShape


func _on_pendulum_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
