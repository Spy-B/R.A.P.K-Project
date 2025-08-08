extends Control

#@export var mainMenu: PackedScene
@export_file("*.tscn") var first_scene: String

@onready var feed_effect: CanvasLayer = $FeedEffect
@onready var timer: Timer = $Timer

func _ready() -> void:
	Global.next_scene = first_scene

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.visible = false

func _on_go_back_pressed() -> void:
	if !Global.in_game:
		self.visible = false

func _on_slot_1_pressed() -> void:
	Global.selected_slot = 1
	feed_effect.feed_out()
	
	timer.start()
	
	Global.saving_slots.slot2.last_one = false
	Global.saving_slots.slot3.last_one = false

func _on_slot_2_pressed() -> void:
	Global.selected_slot = 2
	feed_effect.feed_out()
	
	timer.start()
	
	Global.saving_slots.slot1.last_one = false
	Global.saving_slots.slot3.last_one = false

func _on_slot_3_pressed() -> void:
	Global.selected_slot = 3
	feed_effect.feed_out()
	
	timer.start()
	
	Global.saving_slots.slot1.last_one = false
	Global.saving_slots.slot2.last_one = false

func _on_timer_timeout() -> void:
	Global.started_new_game = true
	Global.current_slot = Global.default_values()

	Global.save_game("lvl", first_scene)
	get_tree().change_scene_to_packed(Global.loading_scene)
