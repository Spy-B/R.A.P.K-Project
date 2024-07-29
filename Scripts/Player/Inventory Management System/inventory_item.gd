@tool
extends Node2D

@export_placeholder("Type") var item_type = ""
@export_placeholder("Name") var item_name = ""
@export var item_texture: Texture
@export var item_texture_size: float = 1
@export var item_icon_size: float = Global.inventory_slot_icon_size
@export_placeholder("Effect") var item_effect = ""
var scene_path: String = "res://Scenes/Player/Inventory Management System/inventory_item.tscn"

@export var playerGroup: String

@onready var icon_sprite = $Sprite2D

var player_in_range = false

func _ready():
	if !Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		icon_sprite.scale.x = item_texture_size
		icon_sprite.scale.y = item_texture_size
		
	item_icon_size = Global.inventory_slot_icon_size


@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Engine.is_editor_hint():
		icon_sprite.texture = item_texture
		icon_sprite.scale.x = item_texture_size
		icon_sprite.scale.y = item_texture_size
	
	if player_in_range && Input.is_action_just_pressed("interact"):
		pickup_item()

func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"item_texture_size": item_texture_size,
		"item_icon_size": item_icon_size,
		"effect": item_effect,
		"scene_path": scene_path
	}
	if Global.player_node:
		Global.add_item(item)
		self.queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group(playerGroup):
		player_in_range = true
		body.interact_ui.visible = true 

func _on_area_2d_body_exited(body):
	if body.is_in_group(playerGroup):
		player_in_range = false
		body.interact_ui.visible = false

# Sets the item's dictionary data
func set_item_data(data):
	item_type = data["type"]
	item_name = data["name"]
	item_effect = data["effect"]
	item_texture = data["texture"]
	item_texture_size = data["item_texture_size"]
	item_icon_size = data["item_icon_size"]

# Set the items values for spawning
@warning_ignore("shadowed_variable_base_class")
func initiate_items(type, name, effect, texture):
	item_type = type
	item_name = name
	item_effect = effect
	item_texture = texture
