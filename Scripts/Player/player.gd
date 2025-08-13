extends CharacterBody2D

## runtime variables
var runtime_vars: Dictionary = {
	"movement_weight": 0.2,
	"damaged": false,
	"just_respawn": false,
	"have_coyote": true,
	"jump_points": 0,
	"dash_points": 0,
	"combo_points": 2,
	## Play Next as soon as possible
	"p_n_s_p": false,
	"can_fire": true,
	# TODO this functionality is not done yet
	#"in_combo_fight": false,
	#"combo_fight_points": 0,
	"interaction_detected": false,
	"obj_you_interact_with": null,
	"start_interact": false,
	"npc_detected": false,
	"npc_you_talk_to": null,
	"start_dialogue": false,
	"is_in_dialogue": false,
}


@export_group("Player States")
@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var jumpingState: State
@export var fallingState: State
@export var landingState: State
@export var dashingState: State
@export var attackingState: State
@export var shootingState: State
@export var reloadingState: State
@export var interactState: State
@export var talkingState: State
@export var damagingState: State
@export var deathState: State
@export var respawningState: State


@export_group("Walking Ability")
@export var walkingAbility: bool = true
@export var walkSpeed: int = 120

@export_group("Running Ability")
@export var runningAbility: bool = true
@export var runSpeed: int = 200
@export var acceleration: int = 20

@export_group("Jumping Ability")
@export var jumpingAbility: bool = true
@export var jumpPower: int = 300
@export var jumpWeight: float = 0.05
@export var jumpPoints: int = 1

@export_group("Dashing Ability")
@export var dashingAbility: bool = true
var dash_dir: Vector2 = Vector2.RIGHT
@export_range(500, 5000, 100) var dashPower: float = 2500
@export_range(100, 1000, 50) var dashLength: float = 250
@export_range(1, 10, 1, "or_greater") var dashPoints: int = 1

@export_group("Attacking Ability")
@export var attackingAbility: bool = true

@export_group("Shooting Ability")
@export var shootingAbility: bool = true
@export var bulletScene: PackedScene = PackedScene.new()

@export var infiniteAmmo: bool = false
@export var ammoInMag: int = 9
@export var maxAmmo: int = 9
@export var extraAmmo: int = 999

@export var autoShoot: bool = false
@export_range(0, 0.5, 0.02) var shootingTime: float = 0.5
@export_range(0, 1, 0.02) var reloadingTime: float = 1.0


@export_group("Physics")
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var falling_gravity: float = 1280.0

@export_group("Groups")
@export var enemyGroup: String = "Enemy"
@export var friendlyGroup: String = "Friendly"
@export var interactionGroup: String = "Interaction"

@export_group("Others")
@export_range(10, 100, 5, "or_greater") var health: int = 100
var health_bar_tween: Tween

@export var checkpointManager: Node


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
		global_position = Global.current_slot.checkpoint
	
	runtime_vars.dash_points = dashPoints

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	
	# TODO this functionality is not done yet
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
	runtime_vars.just_respawn = false


func _on_npc_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(friendlyGroup):
		runtime_vars.npc_detected = true

func _on_npc_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group(friendlyGroup):
		runtime_vars.npc_detected = false


func _on_interaction_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group(interactionGroup):
		runtime_vars.interaction_detected = true

func _on_interaction_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group(interactionGroup):
		runtime_vars.interaction_detected = false


func _on_dash_cooldown_timeout() -> void:
	runtime_vars.dash_points = dashPoints
