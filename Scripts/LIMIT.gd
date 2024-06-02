extends Area2D

@export_placeholder("Group") var playerGroup: String

func _on_body_entered(body):
	if body.is_in_group(playerGroup):
		await get_tree().create_timer(0.05).timeout
		get_tree().reload_current_scene()
