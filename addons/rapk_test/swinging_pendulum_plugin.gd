@tool
extends Node2D
#class_name SwingingPendulum

var tween: Tween

@export var swingingCenterTexture: Texture
@export var swingingCenterTextureSize: float

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



@onready var swinging_center: Marker2D = Marker2D.new()
@onready var swinging_center_sprite: Sprite2D = Sprite2D.new()
@onready var stick_sprite: Sprite2D = Sprite2D.new()
@onready var pendulum: Area2D = Area2D.new()
@onready var pendulum_sprite: Sprite2D = Sprite2D.new()
@onready var animated_pendulum_sprite: AnimatedSprite2D = AnimatedSprite2D.new()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
@onready var visible_on_screen_enabler: VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()

func _ready() -> void:
	add_child(swinging_center)
	swinging_center.add_child(stick_sprite)
	swinging_center.add_child(swinging_center_sprite)
	swinging_center.add_child(pendulum)
	pendulum.add_child(pendulum_sprite)
	pendulum.add_child(animated_pendulum_sprite)
	pendulum.add_child(collision_shape)
	add_child(visible_on_screen_notifier)
	visible_on_screen_notifier.add_child(visible_on_screen_enabler)
	
	visible_on_screen_notifier.scale = Vector2(50.0, 50.0)
	visible_on_screen_enabler.enable_node_path = visible_on_screen_notifier.scene_file_path
	
	pendulum.set_collision_layer_value(5, true)
	pendulum.set_collision_layer_value(1, false)
	pendulum.set_collision_mask_value(9, true)
	
	pendulum.body_entered.connect(_on_pendulum_body_entered)
	
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD).set_loops()
	tween.tween_property(swinging_center, "rotation_degrees", -75.0, swingTime).from(75.0)
	tween.tween_property(swinging_center, "rotation_degrees", 75.0, swingTime).from(-75.0)
	
	apply_preperties()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_preperties()

func _physics_process(_delta: float) -> void:
	pass


func apply_preperties() -> void:
	if swingingCenterTexture:
		swinging_center_sprite.texture = swingingCenterTexture
		swinging_center_sprite.scale.x = swingingCenterTextureSize
		swinging_center_sprite.scale.y = swingingCenterTextureSize
	
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
	
	pass

func _on_pendulum_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
