extends Camera2D

var shake_amount: Vector2 = Vector2.ZERO
var default_offset: Vector2

@onready var timer: Timer = $Timer

func _ready() -> void:
	set_process(false)
	randomize()

func _process(_delta: float) -> void:
	offset = Vector2(randf_range(-1 ,1) * shake_amount.x, shake_amount.y)

func shake(time: float, amount: Vector2) -> void:
	default_offset = offset
	
	timer.wait_time = time
	shake_amount = Vector2(offset.x + amount.x, offset.y + amount.y)
	set_process(true)
	timer.start()

func _on_timer_timeout() -> void:
	set_process(false)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "offset", default_offset, 0.1)
