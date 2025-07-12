extends Control

var intro_scene: String = "uid://dqcfgrrxg0lip"
var main_menu_scene: String = "uid://cvplrh5krh46n"

func _ready() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	ResourceLoader.load_threaded_request(intro_scene)
	ResourceLoader.load_threaded_request(main_menu_scene)

func _process(_delta: float) -> void:
	var progress: Array = []
	if ResourceLoader.load_threaded_get_status(intro_scene, progress) == ResourceLoader.THREAD_LOAD_LOADED && ResourceLoader.load_threaded_get_status(main_menu_scene, progress) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		await get_tree().create_timer(5).timeout
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false)
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(intro_scene)
		get_tree().change_scene_to_packed(new_scene)
