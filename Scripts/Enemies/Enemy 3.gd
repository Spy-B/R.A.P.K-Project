extends CharacterBody2D

var motion = Vector2(0, 0)
@export var speed = 100
@export var gravity = 98

@export var canMove = true
var isMovingLeft = true

@export var group: String
@export var lifePoints: float = Global.enemiesLifePoints

func _ready():
	if group != "":
		self.add_to_group(group)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	
	if canMove:
		Move()
	else:
		motion.x = 0
	
	Gravity()
	Death()
	


func Gravity():
	if !is_on_floor():
		motion.y += gravity

func Move():
	motion.x = -speed if isMovingLeft else speed
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x
	if $RayCast2D2.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x

func Death():
	if lifePoints == 0:
		queue_free()
	
