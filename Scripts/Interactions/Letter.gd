extends Node2D

@export_multiline var letter:String = ""
@export var playerGroup: String


@onready var UI = $UI
#@onready var control = $CanvasLayer/Control
@onready var texture_rect = $UI/Control/TextureRect
@onready var label = $UI/Control/Label


var player_in_range = false

func _ready():
	label.text = letter

@warning_ignore("unused_parameter")
func _process(delta):
		if Input.is_action_just_pressed("interact") && player_in_range:
			UI.visible = !UI.visible
			get_tree().paused = !get_tree().paused

func _on_area_2d_body_entered(body):
	if body.is_in_group(playerGroup):
		player_in_range = true
		body.interact_ui.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group(playerGroup):
		player_in_range = false
		body.interact_ui.visible = false 
