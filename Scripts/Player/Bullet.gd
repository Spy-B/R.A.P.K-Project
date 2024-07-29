extends Area2D

var motion := Vector2.ZERO
@export var speed := 2000
var dir = 1
@export_range(0, 10) var timeScale: float = 1

@export var followLvlSceneTime := true
@export var followPlayerTime := true

var shooter = null
@export var enemiesGroup: String

@onready var timer = $Timer

func _ready():
	motion = Vector2(speed, 0).rotated(rotation)
	timer.one_shot = true

func _physics_process(delta):
	if followLvlSceneTime:
		timeScale = Global.timeScale
	elif followPlayerTime:
		timeScale = shooter.bulletTimeScale
	
	position += motion * delta * timeScale

func _on_Bullet_body_entered(body):
	if body == shooter:
		return
	queue_free()
	
	if body.is_in_group(enemiesGroup):
		#body.queue_free()
		body.lifePoints -= 1
		#body.position.x = shooter.shooting().
		#body.get_node("AnimatedSprite2D").play("Die")
		shooter.killCombo += 1


func _on_Timer_timeout():
	queue_free()
