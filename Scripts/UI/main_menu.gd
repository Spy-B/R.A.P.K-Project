extends Control

@export var next_scene: PackedScene

func _ready():
	pass

func _on_button_pressed():
	Global.nextScene = next_scene.resource_path
	get_tree().change_scene_to_packed(Global.loadingScreen)
