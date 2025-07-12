extends Node

var connected_portal: Variant

@export var portal_1: Node2D
@export var portal_2: Node2D
@export var player: CharacterBody2D

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	match connected_portal:
		portal_1:
			player.global_position = portal_2.spawn_position.global_position
		portal_2:
			player.global_position = portal_1.spawn_position.global_position
	
	connected_portal = null
	pass
