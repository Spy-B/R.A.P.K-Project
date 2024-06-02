extends Node2D

var timer = Timer.new()

func _ready():
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	#timer.connect("timeout",self,"do_this")
	#timer.wait_time = 3
	#timer.one_shot = true
	#add_child(timer)
	#timer.start()
	pass

#func do_this():
	#print('wait 3 seconds and do this....')

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
