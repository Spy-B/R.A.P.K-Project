extends Control

@export_file("*.tscn") var main_menu: String
@export_file("*.tscn") var load_menu: String
@export_file("*.tscn") var options_menu: String

@export var phoneUI: CanvasLayer

@onready var load_game: Control = $LoadGame
@onready var settings: Control = $Settings


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if load_game.visible:
			load_game.visible = false
		elif settings.visible:
			settings.visible = false
		else:
			_on_resume_pressed()

func _on_resume_pressed() -> void:
	visible = !visible
	var newPauseState: bool = !get_tree().paused
	get_tree().paused = newPauseState
	visible = newPauseState
	
	if OS.get_name() == "Android":
		phoneUI.visible = !phoneUI.visible
	
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_restart_pressed() -> void:
	_on_resume_pressed()
	Global.started_new_game = false
	Global.next_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_packed(Global.loading_scene)

func _on_load_game_pressed() -> void:
	load_game.visible = true

func _on_options_pressed() -> void:
	settings.visible = true

func _on_main_menu_pressed() -> void:
	_on_resume_pressed()
	get_tree().change_scene_to_file(main_menu)
