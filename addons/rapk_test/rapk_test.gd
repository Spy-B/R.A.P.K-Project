@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("SwingingPendulum", "Node2D", preload("swinging_pendulum_plugin.gd"), preload("res://icon.svg"))
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("SwingingPendulum")
	pass
