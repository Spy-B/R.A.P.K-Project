extends Node2D

@export_multiline var letter: String
#@export var playerGroup: String = "Player"
@export var player: CharacterBody2D

@onready var ui: CanvasLayer = $UI
@onready var texture_rect: TextureRect = $UI/Control/TextureRect
@onready var label: Label = $UI/Control/Label
@onready var quit: Button = $UI/Control/Quit

var player_in_range: bool = false

func _ready() -> void:
	label.text = letter
	
	if OS.get_name() == "Android":
		quit.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && player_in_range:
		_on_quit_pressed()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player_in_range = true
		body.interaction_detected = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player_in_range = false
		body.interaction_detected = false


func _on_quit_pressed() -> void:
	ui.visible = !ui.visible
	player.ui.interact_key.visible = !player.ui.interact_key.visible
	
	if OS.get_name() == "Android":
		player.phone_ui.visible = !player.phone_ui.visible
	
	get_tree().paused = !get_tree().paused
