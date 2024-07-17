extends Node2D

@export_group("Time Scale Controlling")
@export_range(0, 2) var TimeScale: float = 1
var defaultTimeScale = 1
@export var slowTime: float = 0.5
@export var timeIsSlow = false

@onready var time_scale_timer = $TimeScaleTimer
@export var waitTime: float = 1

func _ready():
	
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	Global.timeScale = TimeScale
	time_scale_timer.wait_time = waitTime
	if Input.is_action_just_pressed("slow_motion") && timeIsSlow == false:
		TimeScale = slowTime
		timeIsSlow = true
		time_scale_timer.start()
	elif Input.is_action_just_pressed("slow_motion") && timeIsSlow:
		TimeScale = defaultTimeScale
		timeIsSlow = false
	
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()

#func TimeScaleControl():
	#pass

func _on_time_scale_timer_timeout():
	TimeScale = defaultTimeScale
	timeIsSlow = false
