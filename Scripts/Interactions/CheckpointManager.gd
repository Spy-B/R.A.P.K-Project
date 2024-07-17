extends Node

var last_position
@export var player: CharacterBody2D

func _ready():
	last_position = player.global_position
