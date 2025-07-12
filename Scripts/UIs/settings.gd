extends Control

@onready var full_screen_check_box: CheckBox = $ScrollContainer/VBoxContainer/FullScreen
@onready var master_slider: HSlider = $ScrollContainer/VBoxContainer/MasterSlider
@onready var sfx_slider: HSlider = $ScrollContainer/VBoxContainer/SFXSlider
@onready var dialogue_sound_slider: HSlider = $ScrollContainer/VBoxContainer/DialogueSlider

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.visible = false

#func _on_go_back_pressed() -> void:
	#if !Global.in_game:
		#self.visible = false
