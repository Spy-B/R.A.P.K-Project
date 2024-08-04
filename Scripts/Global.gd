extends Node

@export_range(0, 10) var timeScale = 1

@export var ammo_in_mag = 0
@export var extra_ammo = 0
@export var max_ammo = 0

@export var enemy_ammo_in_mag = 0
@export var enemy_extra_ammo = 0
@export var enemy_max_ammo = 0

@export var meleeComboCounter = 0
@export var killComboCounter = 0

@export var enemiesLifePoints = 2
@export var playerHealthValue:float = 100

@export var inConversation := false

var camera = null


var inventory = []

signal inventory_updated

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Scenes/Player/Inventory Management System/Inventory_slot.tscn")
@export var inventory_slot_icon_size: int = 5

var loadingScreen = preload("res://Scenes/UI/Loading.tscn")
var nextScene = "res://Scenes/UI/Main Menu.tscn"

func _ready():
	inventory.resize(30)
	

#func load_screen_to_scene(Target: String) -> void:
	#var loadingScreen = preload("res://Scenes/UI/loading.tscn").instantiate()
	#

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false

# Removes an item from the inventory based on type and effect
func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

# Increase inventory size dynamically
func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()

# Sets the player reference for inventory interactions
func set_player_reference(player):
	player_node = player

# Adjusts the drop position to avoid overlapping with nearby items
func adjust_drop_position(position):
	var radius = 5
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position

# Drops an item at a specified position, adjusting for nearby items
func drop_item(item_data, drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	item_instance.queue_free()
	#get_tree().current_scene.add_child(item_instance)
