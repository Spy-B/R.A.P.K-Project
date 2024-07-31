extends Control

@onready var animation_player = $AnimationPlayer

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().create_timer(2).timeout
	animation_player.play("Feed In")
	await get_tree().create_timer(4).timeout
	animation_player.play("Feed Out")
	await get_tree().create_timer(4).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/Main Menu.tscn")
