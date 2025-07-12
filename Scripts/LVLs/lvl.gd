extends Node2D

@export_group("Time Scale Controller")
var default_time_scale: float = 1.0
@export_range(0, 2, 0.1) var slowTime: float = 0.5
@export var timeIsSlow: bool = false

@onready var time_scale_timer: Timer = $TimeScaleTimer
@export var waitTime: float = 1.0

#NOTE: Add the lvl number system in order to detect the nearset save to the game end. (must use the Global Script) - {or we can use the played time}
#var lvl_number: int

func _ready() -> void:
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	Global.save_game("lvl", self.scene_file_path)
	Global.in_game = true
	pass

func _process(_delta: float) -> void:
	time_scale_timer.wait_time = waitTime
	
	if Input.is_action_just_pressed("slow_motion") && !timeIsSlow:
		Global.timeScale = slowTime
		timeIsSlow = true
		time_scale_timer.start()
	
	elif Input.is_action_just_pressed("slow_motion") && timeIsSlow:
		Global.timeScale = default_time_scale
		timeIsSlow = false
	
	if Input.is_action_just_pressed("restart"):
		Global.next_scene = self.scene_file_path
		get_tree().change_scene_to_packed(Global.loading_scene)
	
	if Input.is_action_just_pressed("super"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

#func TimeScaleControl():
	#pass

func _on_time_scale_timer_timeout() -> void:
	Global.timeScale = default_time_scale
	timeIsSlow = false
