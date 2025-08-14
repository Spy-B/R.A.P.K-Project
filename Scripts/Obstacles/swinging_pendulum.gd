@tool
extends Node2D
#class_name SwingingPendulum

var tween: Tween

@export var swingingCenterTexture: Texture
@export_range(0.05, 0.5, 0.05) var swingingCenterTextureScale: float = 0.1

@export_group("Stick Properties")
@export var stickTexture: Texture
@export_range(0.1, 1.0, 0.05) var stickTextureScale: float = 1.0
@export var rotated: bool = false

@export_group("Pendulum Properties")
@export var pendulumTexture: Texture
@export var animatedPendulumSprite: SpriteFrames
@export var animeName: StringName = "default"
@export_range(0.1, 1.0, 0.05) var pendulumScale: float = 1.0
@export var collisionShape: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export_range(0, 100, 5, "or_greater") var damage: int = 25
@export_range(0.1, 1.0, 0.05) var swingTime: float = 2.0


@onready var swinging_center: Marker2D = $SwingingCenter
@onready var stick_sprite: Sprite2D = $SwingingCenter/StickSprite
@onready var swining_center_sprite: Sprite2D = $SwingingCenter/SwiningCenterSprite

@onready var pendulum: Area2D = $SwingingCenter/Pendulum
@onready var pendulum_sprite: Sprite2D = $SwingingCenter/Pendulum/PendulumSprite
@onready var animated_pendulum_sprite: AnimatedSprite2D = $SwingingCenter/Pendulum/AnimatedPendulumSprite
@onready var collision_shape: CollisionShape2D = $SwingingCenter/Pendulum/CollisionShape2D


func _ready() -> void:
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_loops()
	tween.bind_node(self)
	tween.tween_property(swinging_center, "rotation_degrees", -75.0, swingTime).from(75.0)
	tween.tween_property(swinging_center, "rotation_degrees", 75.0, swingTime).from(-75.0)
	
	
	apply_properties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

func _physics_process(_delta: float) -> void:
	pass


func apply_properties() -> void:
	if swingingCenterTexture:
		swining_center_sprite.texture = swingingCenterTexture
		swining_center_sprite.scale.x = swingingCenterTextureScale
		swining_center_sprite.scale.y = swingingCenterTextureScale
	
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
		body.runtime_vars.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
