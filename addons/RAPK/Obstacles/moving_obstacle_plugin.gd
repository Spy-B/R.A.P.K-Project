@tool
extends Path2D

var tween: Tween

@export var loop: bool = true
var speed: float = 1.0
@export var speedScale: float = 1.0

@export_group("Preperties")
@export var texture: Texture
@export var animatedTexture: SpriteFrames
@export var animeName: StringName = "default"

@export var textureScale: Vector2 = Vector2(1.0, 1.0)

@export var collisionShape: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export var damage: int = 25


@onready var path_follower: PathFollow2D = PathFollow2D.new()
@onready var remote_transform: RemoteTransform2D = RemoteTransform2D.new()

@onready var obstacle: Area2D = Area2D.new()
@onready var obstacle_sprite: Sprite2D = Sprite2D.new()
@onready var animated_sprite: AnimatedSprite2D = AnimatedSprite2D.new()
@onready var collision_shape: CollisionShape2D = CollisionShape2D.new()

@onready var animation_player: AnimationPlayer = AnimationPlayer.new()

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = VisibleOnScreenNotifier2D.new()
@onready var visible_on_screen_enabler: VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()

func _ready() -> void:
	self.add_child(path_follower)
	path_follower.add_child(remote_transform)
	self.add_child(obstacle)
	obstacle.add_child(obstacle_sprite)
	obstacle.add_child(animated_sprite)
	obstacle.add_child(collision_shape)
	obstacle.add_child(visible_on_screen_notifier)
	visible_on_screen_notifier.add_child(visible_on_screen_enabler)
	self.add_child(animation_player)
	
	remote_transform.remote_path = obstacle.scene_file_path
	remote_transform.update_rotation = false
	remote_transform.update_scale = false
	#remote_transform.force_update_cache()
	
	obstacle.set_collision_layer_value(1, false)
	obstacle.set_collision_layer_value(5, true)
	obstacle.set_collision_mask_value(9, true)
	obstacle.body_entered.connect(_on_area_2d_body_entered)
	
	visible_on_screen_notifier.scale = Vector2(50.0, 50.0)
	visible_on_screen_enabler.enable_node_path = visible_on_screen_notifier.scene_file_path
	
	self.curve = null
	
	
	if loop && curve != null:
		#animation_player.play()
		set_physics_process(false)
		
		pass
	

	
	apply_preperties()

func _process(_delta: float) -> void:

	
	
	
	if Engine.is_editor_hint():
		apply_preperties()

func _physics_process(_delta: float) -> void:
	pass


func apply_preperties() -> void:
	if loop && curve != null && curve.get_baked_length() != null:
		tween = get_tree().create_tween().set_loops()
		tween.tween_property(path_follower, "progress_ratio", 1.0, 1.0).from(0.0)
		tween.tween_interval(0.5)
		tween.tween_property(path_follower, "progress_ratio", 0.0, 1.0).from(1.0)
	
	
	if animatedTexture:
		animated_sprite.sprite_frames = animatedTexture
	
		if !animated_sprite.is_playing():
			animated_sprite.play(animeName)
	
	else:
		obstacle_sprite.texture = texture
	
	
	obstacle_sprite.scale = textureScale
	animated_sprite.scale = textureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	animation_player.speed_scale = speedScale


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		body.health -= damage
		body.damaged = true
		body.camera.shake(0.2, Vector2(2.0, 2.0))
