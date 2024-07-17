@tool
extends Control

@onready var item_icon = $InnerBorder/ItemIcon
@export var item_icon_size = Global.inventory_slot_icon_size
@onready var item_quantity = $InnerBorder/ItemQuantity
@onready var detailes_panel = $DetailesPanel
@onready var item_name = $DetailesPanel/ItemName
@onready var item_type = $DetailesPanel/ItemType
@onready var item_effect = $DetailesPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var discard_warning = $DiscardWarning
@onready var ok_button = $DiscardWarning/DiscardWarningWin/OKButton
@onready var cancel_button = $DiscardWarning/DiscardWarningWin/CancelButton

var item = null

func _ready():
	detailes_panel.visible = false
	usage_panel.visible = false
	discard_warning.visible = false
	
	if !Engine.is_editor_hint():
		item_icon.scale.x = item_icon_size
		item_icon.scale.y = item_icon_size
	
	Global.inventory_slot_icon_size = item_icon_size

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Engine.is_editor_hint():
		item_icon.scale.x = item_icon_size
		item_icon.scale.y = item_icon_size
	
	if item != null && item["effect"] == "Handgun Mag":
		if Global.player_node:
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])

func _on_item_button_pressed():
	if item != null && item["effect"] != "Handgun Mag":
		usage_panel.visible = !usage_panel.visible

func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		detailes_panel.visible = true

func _on_item_button_mouse_exited():
	detailes_panel.visible = false

func set_empty():
	item_icon.texture = null
	item_quantity.text = ""

func set_item(new_item):
	item = new_item
	item_icon.texture = new_item["texture"]
	item_quantity.text = str(item["quantity"])
	item_name.text = str(item["name"])
	item_type.text = str(item["type"])
	if item["effect"] != "":
		item_effect.text = str("+ ", item["effect"])
	else:
		item_effect.text = ""

# Remove item from inventory and drop it back into the world        		
func _on_drop_button_pressed():
	discard_warning.visible = true

# Remove item from inventory, use it, and apply its effect (if possible)		
func _on_use_button_pressed():
	usage_panel.visible = false
	discard_warning.visible = false
	if item != null && item["effect"] != "":
		if Global.player_node:
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])
		else:
			print("Player could not be found")


func _on_ok_button_pressed():
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		usage_panel.visible = false


func _on_cancel_button_pressed():
	discard_warning.visible = false
