extends Area2D

@export_range(0, 1, 0.1) var time: float = 0.4;

@export_group("Animations List")
@export_placeholder("Animation") var attackAnimation: String
@export_placeholder("Animation") var stopAnimation: String

@export_group("Camera Shake")
@export var shakeAmount: Vector2 = Vector2.ZERO
@export var shakeTime: float = 1.0

@export_group("Other")
@export var player: CharacterBody2D

var playerIsInTrap: bool = false
var trapIsOpened: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_start_timer: Timer = $animation_start_timer
@onready var animation_stop_timer: Timer = $animation_stop_timer

func _ready() -> void:
	animation_start_timer.wait_time = time
	animation_stop_timer.wait_time = time

func _process(_delta: float) -> void:
	if playerIsInTrap:
		animation_start_timer.start()
		set_process(false)

func player_enter_to_trap(body: Node2D) -> void:
	if body == player:
		playerIsInTrap = true

func player_exited_the_trap(body: Node2D) -> void:
	if body == player:
		playerIsInTrap = false

func _on_animation_start_timer_timeout() -> void:
	if !trapIsOpened:
		animation_player.play(attackAnimation)
		trapIsOpened = true
	
	if playerIsInTrap:
		player.health -= 40
		player.camera.shake(shakeTime, shakeAmount)
		
		animation_stop_timer.start();

func _on_animation_stop_timer_timeout() -> void:
	playerIsInTrap = false
	set_process(false)
	set_deferred("monitoring", false)
