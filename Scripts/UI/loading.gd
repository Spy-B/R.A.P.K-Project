extends Control

@export_file("*.tscn") var next_scene: String = "res://Scenes/UI/main_menu.tscn"

@onready var loading_icon = $LoadingIcon
@onready var animation_player = $AnimationPlayer
@onready var color_rect_2 = $ColorRect2

func _ready():
	ResourceLoader.load_threaded_request(Global.nextScene)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	loading_icon.play("Loading")
	animation_player.play("Loading Text")
	color_rect_2.visible = false

@warning_ignore("unused_parameter")
func _process(delta):
	var progress = []
	if ResourceLoader.load_threaded_get_status(Global.nextScene, progress) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		animation_player.play("Transation Effect")
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(Global.nextScene)
		get_tree().change_scene_to_packed(new_scene)
	##Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
