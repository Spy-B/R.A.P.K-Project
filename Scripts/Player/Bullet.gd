extends Area2D

var motion = Vector2.ZERO
@export var speed = 1000
var shooter = null
@export var enemiesGroup: String

func _ready():
	motion = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	position += motion * delta
	

func _on_Bullet_body_entered(body):
	if body == shooter:
		return
	queue_free()
	if body.is_in_group(enemiesGroup):
		#body.queue_free()
		body.lifePoints -= 1
		#body.get_node("AnimatedSprite2D").play("Die")
		shooter.killCombo += 1


func _on_Timer_timeout():
	queue_free()
