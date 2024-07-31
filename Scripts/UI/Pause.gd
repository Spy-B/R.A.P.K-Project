extends Control

@export_file("*.tscn") var restart_scene: String
@export_file("*.tscn") var options_scene: String

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Input.is_action_just_released("pause"):
		$VBoxContainer.visible = !$VBoxContainer.visible
		var newPauseState = !get_tree().paused
		get_tree().paused = newPauseState
		visible = newPauseState

func _on_button_pressed():
	$VBoxContainer.visible = !$VBoxContainer.visible
	var newPauseState = !get_tree().paused
	get_tree().paused = newPauseState
	visible = newPauseState

func _on_button_2_pressed():
	pass # Replace with function body.

func _on_button_3_pressed():
	get_tree().quit()
