extends Node2D


# Variables to control the skew and movement animation
var skew_amount = 0.30 # Amount to skew
var move_amount = 0.1 # Amount to move left and right
var animation_speed = 1.0 # Speed 
var time_elapsed = 0.0

func _process(delta):
	# Increment the time elapsed
	time_elapsed += delta * animation_speed
	
	# Calculate the new skew value using a sine wave for smooth oscillation
	
	var new_skew = skew_amount * sin(time_elapsed)
	self.skew = new_skew
	
	# Calculate the new position value using a sine wave for smooth oscillation
	
	var new_position_offset = move_amount * sin(time_elapsed)
	self.position.x = self.position.x + new_position_offset * delta
