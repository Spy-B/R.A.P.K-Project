extends Control

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Input.is_action_just_released("pause"):
		var newPauseState = not get_tree().paused
		get_tree().paused = newPauseState
		visible = newPauseState
