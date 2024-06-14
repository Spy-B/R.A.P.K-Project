extends Control

@export_file("*.tscn") var next_scene: String

func _ready():
	pass

func _on_button_pressed():
	Global.nextScene = next_scene
	get_tree().change_scene_to_packed(Global.loadingScreen)
