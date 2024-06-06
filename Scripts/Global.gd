extends Node

@export var ammo_in_mag = 0
@export var extra_ammo = 0
@export var max_ammo = 0

@export var meleeComboCounter = 0
@export var killComboCounter = 0

@export var enemiesLifePoints = 0

var inventory = []

signal inventory_updated

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Scenes/Player/Inventory Management System/Inventory_slot.tscn")

func _ready():
	inventory.resize(30)

func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("Item added", inventory)
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("Item added", inventory)
			return true
	return false

func remove_item():
	inventory_updated.emit()

func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
