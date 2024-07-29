extends Control

@export_file("*.tscn") var nextScene: String
@export_file("*.tscn") var nextScene2: String

func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)
	ResourceLoader.load_threaded_request(nextScene)
	ResourceLoader.load_threaded_request(nextScene2)

func _process(delta):
	var progress = []
	if ResourceLoader.load_threaded_get_status(nextScene, progress) == ResourceLoader.THREAD_LOAD_LOADED && ResourceLoader.load_threaded_get_status(nextScene2, progress) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		#await get_tree().create_timer(10).timeout
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, false)
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(nextScene)
		get_tree().change_scene_to_packed(new_scene)
