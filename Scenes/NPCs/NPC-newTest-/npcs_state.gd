class_name NPCsState
extends Node

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_group("Movement")
@export var walkSpeed: int = 100
@export var runSpeed: int = 200
var dir: int = 1

@export_group("Animation")
@export_placeholder("Animation") var animationName: String

#@export_group("Others")


var parent: CharacterBody2D
var sprite: Sprite2D
var animation: AnimationPlayer
var gun_barrel: Marker2D
var rgs_timer: Timer

func enter() -> void:
	animation.play(animationName)

func exit() -> void:
	pass

func process_physics(_delta: float) -> NPCsState:
	return null

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	return null
