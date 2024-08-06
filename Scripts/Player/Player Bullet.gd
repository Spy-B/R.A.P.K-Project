extends Area2D

var motion := Vector2.ZERO
@export var speed := 2000
var dir = 1
@export_range(0, 2) var timeScale: float = 1

@export var followLvlSceneTime := true
@export var followPlayerTime := true

var shooter = null
@export var enemiesGroup: String
@export var lvlsGroup: String

@onready var WallImpact = $WallImpact
@onready var sprite_2d = $Sprite2D
@onready var timer = $Timer
@onready var GunBarrelImpact = $GunBarrelImpact

func _ready():
	motion = Vector2(speed, 0).rotated(rotation)
	timer.one_shot = true
	GunBarrelImpact.emitting = true

func _physics_process(delta):
	if followLvlSceneTime:
		timeScale = Global.timeScale
	elif followPlayerTime:
		timeScale = shooter.bulletTimeScale
	
	position += motion * delta * timeScale

func _on_Bullet_body_entered(body):
	if body == shooter:
		return
	
	if body.is_in_group(lvlsGroup):
		WallImpact.emitting = true
		motion.x = 0
		await get_tree().create_timer(0.2).timeout
		queue_free()
	
	sprite_2d.visible = false
	queue_free()
	
	if body.is_in_group(enemiesGroup):
		#body.queue_free()
		body.applyDamage()
		# TODO body.motion.y += 20
		# TODO add slow motion when the bullet hit the enemy
		body.lifePoints -= 1
		shooter.killCombo += 1

func _on_Timer_timeout():
	queue_free()
