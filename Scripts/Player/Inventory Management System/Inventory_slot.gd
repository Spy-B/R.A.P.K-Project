extends Control

@onready var item_icon = $InnerBorder/ItemIcon
@onready var item_quantity = $InnerBorder/ItemQuantity
@onready var detailes_panel = $DetailesPanel
@onready var item_name = $DetailesPanel/ItemName
@onready var item_type = $DetailesPanel/ItemType
@onready var item_effect = $DetailesPanel/ItemEffect
@onready var usage_panel = $UsagePanel

var item = null

func _on_item_button_pressed():
	if item != null:
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
