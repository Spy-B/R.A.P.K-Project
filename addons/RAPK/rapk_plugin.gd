@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("SwingingPendulum", "Node2D", preload("Obstacles/swinging_pendulum_plugin.gd"), preload("res://icon.svg"))
	add_custom_type("SpiningObstacle", "Node2D", preload("Obstacles/spining_obstacle_plugin.gd"), preload("res://addons/ez_dialogue/icon.png"))
	add_custom_type("MovingObstacle", "Path2D", preload("res://addons/RAPK/Obstacles/moving_obstacle_plugin.gd"), preload("res://icon.svg"))

func _exit_tree() -> void:
	remove_custom_type("SwingingPendulum")
	remove_custom_type("SpiningObstacle")
