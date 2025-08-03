@tool
extends Node2D
#class_name SpinningObstacle

@export var spiningCenterTexture: Texture
@export var spiningCenterTextureSize: float = 1.0

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

@onready var spining_center: Marker2D = Marker2D.new()
@onready var spining_center_sprite: Sprite2D = Sprite2D.new()
@onready var stick_sprite: Sprite2D = Sprite2D.new()

@onready var pendulum: Area2D = Area2D.new()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()
@onready var pendulum_sprite: Sprite2D = Sprite2D.new()
@onready var animated_pendulum_sprite: AnimatedSprite2D = AnimatedSprite2D.new()

@onready var pendulum_2: Area2D = Area2D.new()
@onready var collision_shape_2: CollisionShape2D = CollisionShape2D.new()
@onready var pendulum_2_sprite: Sprite2D = Sprite2D.new()
@onready var animated_pendulum_2_sprite: AnimatedSprite2D = AnimatedSprite2D.new()

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
@onready var visible_on_screen_enabler: VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()

func _ready() -> void:
	self.add_child(spining_center)
	spining_center.add_child(stick_sprite)
	spining_center.add_child(spining_center_sprite)

	spining_center.add_child(pendulum)
	pendulum.add_child(collision_shape)
	pendulum.add_child(pendulum_sprite)
	pendulum.add_child(animated_pendulum_sprite)

	spining_center.add_child(pendulum_2)
	pendulum_2.add_child(collision_shape_2)
	pendulum_2.add_child(pendulum_2_sprite)
	pendulum_2.add_child(animated_pendulum_2_sprite)

	spining_center.add_child(visible_on_screen_notifier)
	visible_on_screen_notifier.add_child(visible_on_screen_enabler)


	pendulum.set_collision_layer_value(1, false)
	pendulum.set_collision_layer_value(5, true)
	pendulum.set_collision_mask_value(9, true)

	pendulum_2.set_collision_layer_value(1, false)
	pendulum_2.set_collision_layer_value(5, true)
	pendulum_2.set_collision_mask_value(9, true)

	pendulum.body_entered.connect(_on_pendulum_body_entered)
	pendulum_2.body_entered.connect(_on_pendulum_2_body_entered)

	apply_preperties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_preperties()

func _physics_process(delta: float) -> void:
	spining_center.rotation_degrees += rotatingSpeed * delta


func apply_preperties() -> void:
	if spiningCenterTexture:
		spining_center_sprite.texture = spiningCenterTexture
		spining_center_sprite.scale.x = spiningCenterTextureSize
		spining_center_sprite.scale.y = spiningCenterTextureSize
	
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
