##### Spring Modelling

extends Node2D

#the spring's current velocity
var velocity = 0

#the force being applied to the spring
var force = 0

#the current height of the spring
var height = 0

#the natural position of the spring
var target_height = 0

@export var jointsVisible := false

@onready var collision = $Area2D/CollisionShape2D
@onready var sprite_2d = $Sprite2D

# the index of this spring
#we will set it on initialize
var index = 0

#how much an external object movement will affect this spring
var motion_factor = 0.015

#the last instance this spring collided with
#we check so it won't collide twice
var collided_with = null

#we will trigger this signal to call the splash function
#to make our wave move!
signal splash

@warning_ignore("unused_parameter")
func _process(delta):
	if jointsVisible:
		sprite_2d.visible = true
	else:
		sprite_2d.visible = false

func water_update(spring_constant, dampening):
	## This function applies the hooke's law force to the spring!!
	## This function will be called in each frame
	## hooke's law ---> F =  - K * x 
	
	#update the height value based on our current position
	height = position.y
	
	#the spring current extension
	var x = height - target_height
	
	var loss = -dampening * velocity
	
	#hooke's law:
	force = - spring_constant * x + loss
	
	#apply the force to the velocity
	#equivalent to velocity = velocity + force
	velocity += force
	
	#make the spring move!
	position.y += velocity

func initialize(x_position,id):
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value):
	#this function will set the collision shape size of our springs
	
	var extents = collision.shape.get_size()
	
	#the new extents will mantain the value on the y width
	#the "value" variable is the space between springs, which we already have
	var new_extents = Vector2(value/2, extents.y)
	
	#set the new extents
	collision.shape.set_size(new_extents)
	pass


func _on_Area2D_body_entered(body):
	#called when a body collides with a spring
	
	#if the body already collided with the spring, then do not collide
	if body == collided_with:
		pass
	
	#the body is the last thing this spring collided with
	collided_with = body
	
	#we multiply the motion of the body by the motion factor
	#if we didn't the speed would be huge, depending on your game
	var speed = body.motion.y * motion_factor
	
	#emit the signal "splash" to call the splash function, at our water body script
	emit_signal("splash",index,speed)


func _on_area_2d_body_exited(body):
	#called when a body collides with a spring
	
	#if the body already collided with the spring, then do not collide
	if body == collided_with:
		pass
	
	#the body is the last thing this spring collided with
	collided_with = body
	
	#we multiply the motion of the body by the motion factor
	#if we didn't the speed would be huge, depending on your game
	var speed = body.motion.y * motion_factor
	
	#emit the signal "splash" to call the splash function, at our water body script
	emit_signal("splash",index,speed)
