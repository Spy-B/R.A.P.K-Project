extends Node

var last_position: Vector2
@export var player: CharacterBody2D

func _ready() -> void:
	last_position = Global.saving_slots.slot1.checkpoint
