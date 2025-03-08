class_name State
extends Node

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("Movement")
@export var walkSpeed: int = 120
@export var runSpeed: int = 200

@export_group("Animation")
@export_placeholder("Animation") var animationName: String

@export_group("Input Keys")
@export var runningInput: String = "run"
@export var jumpingInput: String = "jump"
@export var attackingInput: String = "attack"
@export var shootingInput: String = "shoot"

var parent: CharacterBody2D
var animation: AnimationPlayer
var gun_barrel: Marker2D

var coyote_timer: Timer
var jump_buffer_timer: Timer

var state_animation

func enter() -> void:
	animation.play(animationName)
	
	#state_animation = animation_tree["parameters/playback"]
	#state_animation.travel(animationName)

func exit() -> void:
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null
