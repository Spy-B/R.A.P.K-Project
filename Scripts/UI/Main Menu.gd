extends Control

@export_file("*.tscn") var newGame_scene: String
@export_file("*.tscn") var options_scene: String

func _ready():
	pass

func _on_button_pressed():
	Global.nextScene = newGame_scene
	get_tree().change_scene_to_packed(Global.loadingScreen)


func _on_options_pressed():
	Global.nextScene = options_scene
	get_tree().change_scene_to_packed(Global.loadingScreen)


func _on_quit_pressed():
	get_tree().quit()
