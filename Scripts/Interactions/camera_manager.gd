extends Area2D

@export var camera: Node
@export var playerGroup: String = "Player"

@export var cameraOffset: Vector2
@export var cemeraZoom: Vector2

@export var time: float = 1.0

func _ready() -> void:
	if !cemeraZoom:
		cemeraZoom = camera.zoom
	pass

func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	var tween: Tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	if body.is_in_group(playerGroup):
		tween.tween_property(camera, "offset", cameraOffset, time)
		tween.tween_property(camera, "zoom", cemeraZoom, time)
