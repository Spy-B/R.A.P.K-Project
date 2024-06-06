@tool
extends Node2D

@export_placeholder("Type") var item_type = ""
@export_placeholder("Name") var item_name = ""
@export var item_texture: Texture
@export var item_texture_size: float
@export_placeholder("Effect") var item_effect = ""
var scene_path: String = "res://Scenes/inventory_item.tscn"

@onready var icon_sprite = $Sprite2D

var player_in_range = false

func _ready():
	if !Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		icon_sprite.scale.x = item_texture_size
		icon_sprite.scale.y = item_texture_size


func _physics_process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		icon_sprite.scale.x = item_texture_size
		icon_sprite.scale.y = item_texture_size
	
	if player_in_range && Input.is_action_just_pressed("ui_add"):
		pickup_item()

func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"effect": item_effect,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		body.interact_ui.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		body.interact_ui.visible = false
