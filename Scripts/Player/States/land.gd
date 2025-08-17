extends State

#@export var quit_landing_after: float = 0.2
var landing_done: bool = false


func enter() -> void:
	print("[State] -> Landing")
	super()
	
	parent.runtime_vars.have_coyote = true
	parent.runtime_vars.jump_points = parent.jumpPoints
	parent.runtime_vars.dash_points = parent.dashPoints
	
	landing_done = false
	#get_tree().create_timer(quit_landing_after).timeout.connect(func() -> void: landing_done = true)

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points > 0:
		return parent.startJumpingState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	return null

func process_physics(_delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * parent.walkSpeed
	
	if movement != 0:
		if movement > 0:
			parent.player_sprite.scale.x = 1
			parent.dash_dir = Vector2.RIGHT
		else:
			parent.player_sprite.scale.x = -1
			parent.dash_dir = Vector2.LEFT
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !jump_buffer_timer.is_stopped():
		return parent.startJumpingState
	
	if landing_done:
		if !movement && parent.is_on_floor():
			return parent.idleState
		return parent.runningState
	
	return null


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	landing_done = true
