extends Node2D

@export_range(0, 10) var TimeScale: float = 1

var timer = Timer.new()

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	Global.timeScale = TimeScale
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	
