extends Control

@export var LoadingIcon = true
@export var LoadingText = true

@export_file("*.tscn") var next_scene: String = "res://Scenes/UI/Main Menu.tscn"

@onready var loading_icon = $LoadingIcon
@onready var animation_player = $AnimationPlayer
@onready var label_2 = $Label2
@onready var loading_text = $LoadingText
@onready var color_rect_2 = $ColorRect2


func _ready():
	ResourceLoader.load_threaded_request(Global.nextScene)
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if LoadingIcon:
		loading_icon.visible = true
		loading_icon.play("Loading")
	else:
		loading_icon.visible = false
	
	if LoadingText:
		loading_text.visible = true
		animation_player.play("Loading Text")
	else:
		loading_text.visible = false
	
	label_2.visible = false

@warning_ignore("unused_parameter")
func _process(delta):
	var progress = []
	if ResourceLoader.load_threaded_get_status(Global.nextScene, progress) == ResourceLoader.THREAD_LOAD_LOADED:
		loading_icon.visible = false
		loading_text.visible = false
		animation_player.play("press to continue")
		label_2.visible = true
		if Input.is_action_just_pressed("continue"):
			set_process(false)
			animation_player.play("Transation Effect")
			var new_scene: PackedScene = ResourceLoader.load_threaded_get(Global.nextScene)
			get_tree().change_scene_to_packed(new_scene)
	
