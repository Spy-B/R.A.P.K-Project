extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

@export var inStarting: bool = true

func _ready() -> void:
	if inStarting:
		self.visible = true
		feed_in()
	else:
		self.visible = false
		feed_in()

func feed_in() -> void:
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "position", Vector2(color_rect.position.x - 4000.0, color_rect.position.y + 4000.0), 0.8)

func feed_out() -> void:
	self.visible = true
	
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(color_rect, "position", Vector2(color_rect.position.x + 4000.0, color_rect.position.y - 4000.0), 0.8)
