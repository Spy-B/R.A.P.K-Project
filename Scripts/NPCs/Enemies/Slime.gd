extends CharacterBody2D

var motion = Vector2(0, 0)
@export var speed = 100
var gravity = 98
var isMovingLeft = true
@export var group: String
@export var lifePoints = 3

func _ready():
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	motion.x = -speed
	
	motion.x = -speed if isMovingLeft else speed
	
	if !is_on_floor():
		motion.y += gravity
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x
	if $RayCast2D2.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x
	
	self.add_to_group(group)
	
