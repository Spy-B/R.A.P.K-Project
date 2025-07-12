extends Control

#@export_file("*.tscn") var newGame_scene: String
#@export_file("*.tscn") var loadGame_scene: String
#@export_file("*.tscn") var options_scene: String

@onready var new_game: Control = $NewGame
@onready var load_game: Control = $LoadGame
@onready var options: Control = $Options

@onready var feed_effect: CanvasLayer = $FeedEffect

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	Global.in_game = false

func _on_continue_pressed() -> void:
	pass

func _on_new_game_pressed() -> void:
	new_game.visible = true

func _on_load_game_pressed() -> void:
	load_game.visible = true

func _on_options_pressed() -> void:
	options.visible = true

func _on_quit_pressed() -> void:
	feed_effect.feed_out()
	await get_tree().create_timer(1.0).timeout
	
	get_tree().quit()
