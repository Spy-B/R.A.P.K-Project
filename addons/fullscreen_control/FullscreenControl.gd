extends Node

var _save_path_fullscreen_mode = "user://fullscreen_mode.save"
var _toggle_fullscreen_action: StringName = "toggle_fullscreen"

func _ready():
	if not InputMap.has_action(_toggle_fullscreen_action):
		InputMap.add_action(_toggle_fullscreen_action)

		# Alt + Enter
		var inputEventKey = InputEventKey.new()
		inputEventKey.physical_keycode = Key.KEY_ENTER
		inputEventKey.alt_pressed = true

		InputMap.action_add_event(_toggle_fullscreen_action, inputEventKey)
	DisplayServer.window_set_mode(_load_fullscreen_mode())

func _process(delta):
	if Input.is_action_just_pressed(_toggle_fullscreen_action):
			var current_mode = DisplayServer.window_get_mode()
			if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
				_update_fullscreen_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			else:
				_update_fullscreen_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _update_fullscreen_mode(mode: DisplayServer.WindowMode):
	_save_fullscreen_mode(mode)
	DisplayServer.window_set_mode(mode)

func _save_fullscreen_mode(mode: DisplayServer.WindowMode):
	var file_fullscreen_mode = FileAccess.open(_save_path_fullscreen_mode, FileAccess.WRITE)
	file_fullscreen_mode.store_var(mode)

func _load_fullscreen_mode() -> DisplayServer.WindowMode:
	if FileAccess.file_exists(_save_path_fullscreen_mode):
		var file_fullscreen_mode = FileAccess.open(_save_path_fullscreen_mode, FileAccess.READ)
		return file_fullscreen_mode.get_var()
	else:
		return int(ProjectSettings.get_setting("display/window/size/mode"))
