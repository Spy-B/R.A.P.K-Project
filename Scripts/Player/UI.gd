extends CanvasLayer

@onready var texture_progress_bar = $HealthBar/TextureProgressBar

func _on_h_slider_value_changed(value):
	texture_progress_bar.value = value
