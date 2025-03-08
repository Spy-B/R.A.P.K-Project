extends Area2D

@export_group("timer")
@export_range(0, 1) var startingTime: float = 0.4;
@export_range(0, 1) var stopingTime: float = 0.4;

@export_group("Animations List")
@export_placeholder("Animation") var attackAnimation: String
@export_placeholder("Animation") var stopAnimation: String

@export_group("Camera Shake")
@export var amountX: float = 0
@export var amountY: float = 0
@export var shakeTime: float = 1

@export_group("Other")
@export var playerGroup: String;

var playerIsIntheArea := false
var trapIsOpened := false


@onready var animation_player: AnimationPlayer = get_node("AnimationPlayer");
@onready var collision_shape_2d: CollisionShape2D = get_node("CollisionShape2D");
@onready var animation_start_timer: Timer = get_node("animation_start_timer");
@onready var animation_stop_timer: Timer = get_node("animation_stop_timer");


func _ready() -> void:
	animation_trap_timer(startingTime, stopingTime);

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if playerIsIntheArea:
		animation_start_timer.start()
		set_physics_process(false)

func animation_trap_timer(animation_start_time : float, animation_stop_time : float) -> void:
	animation_start_timer.wait_time = animation_start_time;
	animation_stop_timer.wait_time = animation_stop_time;

func player_enter_to_trap(body: Node2D) -> void:
	if body.is_in_group(playerGroup):
		playerIsIntheArea = true

func player_exited_the_trap(body: Node2D) -> void:
	if body.is_in_group(playerGroup):
		playerIsIntheArea = false

func _on_animation_start_timer_timeout() -> void:
	if !trapIsOpened:
		animation_player.play(attackAnimation)
		trapIsOpened = true
	
	if playerIsIntheArea:
		Global.playerHealthValue -= 10
		Global.camera.shake(shakeTime, amountX, amountY)
		
		animation_stop_timer.start();

func _on_animation_stop_timer_timeout() -> void:
	playerIsIntheArea = false
	trapIsOpened = true
	set_physics_process(false)
	set_deferred("monitoring", false)
