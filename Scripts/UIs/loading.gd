extends Control

@onready var loading_icon: AnimatedSprite2D = $LoadingIconControl/LoadingIcon
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var press_label: Label = $PressLabel
@onready var feed_effect: CanvasLayer = $FeedEffect
@onready var timer: Timer = $Timer

func _ready() -> void:
	ResourceLoader.load_threaded_request(Global.next_scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	loading_icon.play("Loading")
	
	if OS.get_name() == "Android":
		press_label.text = "TAP to Continue"
	elif OS.get_name() == "Linux" || "Windows":
		press_label.text = "PRESS any Key to Continue"

func _process(_delta: float) -> void:
	var progress: Array = []
	if ResourceLoader.load_threaded_get_status(Global.next_scene, progress) == ResourceLoader.THREAD_LOAD_LOADED:
		loading_icon.visible = false
		animation_player.play("press to continue")
		press_label.visible = true
		
		if Input.is_anything_pressed():
			set_process(false)
			feed_effect.feed_out()
			
			timer.start()

func _on_timer_timeout() -> void:
	var new_scene: PackedScene = ResourceLoader.load_threaded_get(Global.next_scene)
	get_tree().change_scene_to_packed(new_scene)
