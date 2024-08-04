extends Camera2D

var shake_amount_x: float = 0
var shake_amount_y: float = 0

var default_offset = offset

@onready var timer = $Timer

func _ready():
	set_process(false)
	Global.camera = self
	randomize()

# warning-ignore:unused_argument
@warning_ignore("unused_parameter")
func _process(delta):
	offset = Vector2(randf_range(-1 ,1) * shake_amount_x, shake_amount_y)
	

func shake(time, amountX, amountY):
	timer.wait_time = time
	shake_amount_x = amountX
	shake_amount_y = amountY
	set_process(true)
	timer.start()

func _on_timer_timeout():
	set_process(false)
	var tween = create_tween()
	# FIXME 
	tween.tween_property(self, "offset", default_offset, 0.1)
