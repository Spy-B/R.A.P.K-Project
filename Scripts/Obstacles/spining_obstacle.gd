@tool
extends Node2D
#class_name SpinningObstacle

#var tween: Tween

@export_group("Stick Preperties")
@export var stickTexture: Texture
@export var stickTextureScale: float = 1.0
@export var rotated: bool = false
@export_range(-1000.0, 1000.0, 0.5, "or_less", "or_greater") var rotatingSpeed: float = 100.0

@export_group("Pendulum Preperties")
@export var pendulumTexture: Texture
@export var animatedPendulumSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var pendulumScale: float = 1.0
@export var collisionShape: Shape2D

@export_group("Pendulum 2 Preperties")
@export var pendulum2Texture: Texture
@export var animatedPendulum2Sprite: SpriteFrames
@export var anime2Name: StringName = "default"
@export var pendulum2Scale: float = 1.0
@export var collisionShape2: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export var damage: int = 25


@onready var spining_center: Marker2D = $SpiningCenter
@onready var stick_sprite: Sprite2D = $SpiningCenter/StickSprite

@onready var pendulum: Area2D = $SpiningCenter/Pendulum
@onready var collision_shape: CollisionShape2D = $SpiningCenter/Pendulum/CollisionShape2D
@onready var pendulum_sprite: Sprite2D = $SpiningCenter/Pendulum/PendulumSprite
@onready var animated_pendulum_sprite: AnimatedSprite2D = $SpiningCenter/Pendulum/AnimatedPendulumSprite

@onready var pendulum_2: Area2D = $SpiningCenter/Pendulum2
@onready var collision_shape_2: CollisionShape2D = $SpiningCenter/Pendulum2/CollisionShape2D2
@onready var pendulum_2_sprite: Sprite2D = $SpiningCenter/Pendulum2/Pendulum2Sprite
@onready var animated_pendulum_2_sprite: AnimatedSprite2D = $SpiningCenter/Pendulum2/AnimatedPendulum2Sprite

func _ready() -> void:
	apply_preperties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_preperties()

func _physics_process(delta: float) -> void:
	spining_center.rotation_degrees += rotatingSpeed * delta


func apply_preperties() -> void:
	if stickTexture:
		stick_sprite.texture = stickTexture
		stick_sprite.scale.x = stickTextureScale
		stick_sprite.scale.y = stickTextureScale
		
		if rotated:
			stick_sprite.rotation_degrees = 90.0
		else:
			stick_sprite.rotation_degrees = 0.0
		
		#stick_sprite.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	if animatedPendulumSprite:
		pendulum_sprite.texture = null
		animated_pendulum_sprite.sprite_frames = animatedPendulumSprite
		animated_pendulum_sprite.scale.x = pendulumScale
		animated_pendulum_sprite.scale.y = pendulumScale
		
		if !animated_pendulum_sprite.is_playing():
			animated_pendulum_sprite.play(animeName)
		
		pendulum.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	elif pendulumTexture:
		animated_pendulum_sprite.stop()
		pendulum_sprite.texture = pendulumTexture
		pendulum_sprite.scale.x = pendulumScale
		pendulum_sprite.scale.y = pendulumScale
		
		pendulum.position.y = (stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	
	if animatedPendulum2Sprite:
		pendulum_2_sprite.texture = null
		animated_pendulum_2_sprite.sprite_frames = animatedPendulum2Sprite
		animated_pendulum_2_sprite.scale.x = pendulum2Scale
		animated_pendulum_2_sprite.scale.y = pendulum2Scale
		
		if !animated_pendulum_2_sprite.is_playing():
			animated_pendulum_2_sprite.play(anime2Name)
		
		pendulum_2.position.y = -(stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	elif pendulum2Texture:
		animated_pendulum_2_sprite.stop()
		pendulum_2_sprite.texture = pendulum2Texture
		pendulum_2_sprite.scale.x = pendulum2Scale
		pendulum_2_sprite.scale.y = pendulum2Scale
		
		pendulum_2.position.y = -(stick_sprite.texture.get_height() * stick_sprite.scale.y) / 2
	
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	if collisionShape2:
		collision_shape_2.shape = collisionShape2


func _on_pendulum_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))

func _on_pendulum_2_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
