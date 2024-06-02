extends Area2D

@export_placeholder("Group") var playerGroup: String

func _on_body_entered(body):
	if body.is_in_group(playerGroup):
		body.extraAmmo += 9
		queue_free()
