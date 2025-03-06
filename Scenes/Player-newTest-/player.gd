extends CharacterBody2D

var movementWeight: float = 0.2
var health: int = 100

var isGrounded: bool = true
var have_coyote: bool = true

var combo_points: int = 2
var a_n_s_p: bool = false

@export var checkpointManager: Node

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var gun_barrel: Marker2D = $PlayerSprite/GunBarrel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var state_machine: Node = $StateMachine

@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer

@onready var health_label: Label = $UI/Health

func _ready() -> void:
	state_machine.init(self, gun_barrel, animation_player, coyote_timer, jump_buffer_timer)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
