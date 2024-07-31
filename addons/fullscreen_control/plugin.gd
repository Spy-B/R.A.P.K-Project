@tool
extends EditorPlugin

func _enter_tree():
	add_autoload_singleton("FullscreenControl", "res://addons/fullscreen_control/FullscreenControl.gd")

func _exit_tree():
	remove_autoload_singleton("FullscreenControl")
