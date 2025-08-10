extends State

@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var dashingState: State
@export var attackingState: State
@export var shootingState: State
@export var reloadingState: State
@export var interactState: State
@export var talkingState: State
@export var damagingState: State
@export var deathState: State

func enter() -> void:
	super()
	
	#parent.global_position = Vector2(Global.save_game_dictionary.last_checkpoint)

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("jump") && parent.jumpingAbility:
			return startJumpingState
		
		if event.is_action_pressed("dash") && parent.dash_points > 0:
			return dashingState
		
		if event.is_action_pressed("attack"):
			return attackingState
		
		if event.is_action_pressed("shoot") && parent.shootingAbility:
			return shootingState
		
		if event.is_action_pressed("reload"):
			return reloadingState
		
		if event.is_action_pressed("move_right") || event.is_action_pressed("move_left"):
			if parent.walkingAbility:
				return walkingState
			
			elif parent.runningAbility && !parent.walkingAbility:
				return runningState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	if parent.health <= 0:
		return deathState
	
	if parent.npc_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return talkingState
	
	elif parent.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return interactState
	
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(_delta: float) -> State:
	if !parent.is_on_floor():
		return fallingState
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	if !jump_buffer_timer.is_stopped():
		return startJumpingState
	
	parent.move_and_slide()
	
	return null
