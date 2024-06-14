extends Control

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
func _physics_process(delta):
	var progress = []
	ResourceLoader.load_threaded_get_status(Global.nextScene, progress)
	
	if progress[0] == 1:
		animation_player.play("Transation Effect")
		await get_tree().create_timer(0.2).timeout
		var packed_scene = ResourceLoader.load_threaded_get(Global.nextScene)
		get_tree().change_scene_to_packed(packed_scene)
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
