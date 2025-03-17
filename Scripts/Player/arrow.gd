extends Area2D

var motion: Vector2 = Vector2.ZERO
var dir: int = 1
var shooter: CharacterBody2D = null
@export var target: String

@export var speed: int = 1000

@onready var arrow_sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	motion = Vector2(speed, 0).rotated(rotation)
	

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(0.35).timeout
	position += motion * delta
	arrow_sprite.visible = true


func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	
	if body.is_in_group(target):
		body.health -= 20
		print("[Enemy] -> [Health]: -20")
		
		
		if !body.player_detected:
			body.player_detected = true
			body.cool_down = false
	
	queue_free()
