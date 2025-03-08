extends Area2D

var motion := Vector2.ZERO
@export var speed := 1000
var dir = 1
@export_range(0, 10) var timeScale: float = 1

@export var followLvlSceneTime := true
@export var followPlayerTime := true

var shooter = null
@export var playerGroup: String = "Player"

@onready var timer = $Timer

func _ready() -> void:
	motion = Vector2(speed, 0).rotated(rotation)
	timer.one_shot = true

func _physics_process(delta: float) -> void:
	if followLvlSceneTime:
		timeScale = Global.timeScale
	elif followPlayerTime:
		timeScale = shooter.bulletTimeScale
	
	position += motion * delta # * timeScale

func _on_Bullet_body_entered(body: Node) -> void:
	if body == shooter:
		return
	
	if body.is_in_group(playerGroup):
		body.health -= 20
		body.health_label.text = str(body.health)
	
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
