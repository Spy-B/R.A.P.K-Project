extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	await get_tree().create_timer(1.0).timeout
	animation_player.play("Feed In")
	await get_tree().create_timer(3.0).timeout
	animation_player.play("Feed Out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Feed Out":
		get_tree().change_scene_to_file("uid://cvplrh5krh46n")
