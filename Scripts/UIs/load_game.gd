extends Control

#@export var mainMenu: PackedScene

@onready var feed_effect: CanvasLayer = $FeedEffect
@onready var timer: Timer = $Timer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") && !Global.in_game:
		self.visible = false

func _on_go_back_pressed() -> void:
	if !Global.in_game:
		self.visible = false
	else:
		self.visible = false

func _on_slat_1_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	
	Global.selected_slat = 1
	Global.load_game()
	
	if Global.current_slat.lvl:
		feed_effect.feed_out()
		
		timer.start()
	
	else:
		if Engine.has_singleton("ToastPlugin"):
			var toast_plugin := Engine.get_singleton("ToastPlugin")
			toast_plugin.showToast("Empty", 0, 0, 0, 500)

func _on_slat_2_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	
	Global.selected_slat = 2
	Global.load_game()
	
	if Global.current_slat.lvl:
		feed_effect.feed_out()
		
		timer.start()
	
	else:
		if Engine.has_singleton("ToastPlugin"):
			var toast_plugin := Engine.get_singleton("ToastPlugin")
			toast_plugin.showToast("Empty", 0, 0, 0, 500)

func _on_slat_3_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	
	Global.selected_slat = 3
	Global.load_game()
	
	if Global.current_slat.lvl:
		feed_effect.feed_out()
		
		timer.start()
	
	else:
		if Engine.has_singleton("ToastPlugin"):
			var toast_plugin := Engine.get_singleton("ToastPlugin")
			toast_plugin.showToast("Empty", 0, 0, 0, 500)


func _on_timer_timeout() -> void:
	Global.next_scene = Global.current_slat.lvl
	get_tree().change_scene_to_packed(Global.loading_scene)
