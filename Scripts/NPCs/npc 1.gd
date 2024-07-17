extends CharacterBody2D

var motion = Vector2.ZERO
@export var gravity = 98

@export var walkingSpeed = 150
@export var runningSpeed = 380



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	if !is_on_floor():
		motion.y += gravity
