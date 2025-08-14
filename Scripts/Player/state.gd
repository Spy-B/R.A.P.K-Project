class_name State
extends Node

@export var animationName: StringName

var parent: CharacterBody2D
var animation: AnimationPlayer
var gun_barrel: Marker2D

var coyote_timer: Timer
var jump_buffer_timer: Timer

#var state_animation

func enter() -> void:
	animation.play(animationName)

func exit() -> void:
	pass

func process_physics(_delta: float) -> State:
	return null

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null
