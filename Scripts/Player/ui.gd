extends CanvasLayer

@onready var ammo_label: Label = $AmmoLabel

func _process(_delta: float) -> void:
	ammo_label.text = str("Ammo: ", get_parent().ammoInMag, " / ", get_parent().extraAmmo)
