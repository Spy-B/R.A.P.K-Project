extends CharacterBody2D

var movement: float
var movementWeight: float = 0.2

var health: int = 100
var damaged: bool = false
var just_respawn: bool = false

var isGrounded: bool = true
var have_coyote: bool = true

var dash_dir: Vector2 = Vector2.RIGHT
var dash_points: int = 1

var combo_points: int = 2
var a_n_s_p: bool = false

var in_combo_fight: bool = false
var combo_fight_points: int = 0

var interaction_detected: bool = false
var obj_you_interact_with: Node = null

var start_interact: bool = false

var npc_detected: bool = false
var npc_you_talk_to: Node = null

var start_dialogue: bool = false
var is_in_dialogue: bool = false


@export var checkpointManager: Node

@export var ammoInMag: int = 9
@export var maxAmmo: int = 9
@export var extraAmmo: int = 999

@export_group("Groups")
@export var enemyGroup: String = "Enemy"
@export var friendlyGroup: String = "Friendly"
@export var interactionGroup: String = "Interaction"


@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var gun_barrel: Marker2D = $PlayerSprite/GunBarrel
@onready var interaction_detector: Area2D = $PlayerSprite/InteractionDetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var state_machine: Node = $StateMachine

@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer

@onready var camera: Camera2D = $Camera2D

@onready var ui: CanvasLayer = $UI
@onready var phone_ui: CanvasLayer = $PhoneUI

func _ready() -> void:
	state_machine.init(self, gun_barrel, animation_player, coyote_timer, jump_buffer_timer)
	
	if Global.started_new_game:
		return
	else:
		global_position = Global.current_slat.checkpoint

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
	#if combo_fight_points:
		#in_combo_fight = true
		#ui.combo_counter.text = str(combo_fight_points)
	
	camera_offset()

func camera_offset() -> void:
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	if Input.is_action_just_pressed("move_right"):
		tween.tween_property(camera, "drag_horizontal_offset", 0.4, 0.8)
	elif Input.is_action_just_pressed("move_left"):
		tween.tween_property(camera, "drag_horizontal_offset", -0.4, 0.8)
	else:
		tween.pause()


func respawning_effect() -> void:
	var respawn_tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_loops(8)
	
	respawn_tween.tween_property(player_sprite.material, "shader_parameter/flashValue", 0.0, 0.1)
	respawn_tween.tween_property(player_sprite.material, "shader_parameter/flashValue", 0.6, 0.1)
	respawn_tween.tween_property(player_sprite.material, "shader_parameter/flashValue", 0.0, 0.1)

func _on_respawn_cooldown_timeout() -> void:
	just_respawn = false


func _on_npc_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(friendlyGroup):
		npc_detected = true

func _on_npc_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group(friendlyGroup):
		npc_detected = false


func _on_interaction_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(interactionGroup):
		interaction_detected = true

func _on_interaction_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group(interactionGroup):
		interaction_detected = false


func _on_dash_cooldown_timeout() -> void:
	dash_points = 1
