extends State

@export var idleState: State
@export var walkingState: State
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

@export var acceleration: int = 20

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("jump") && parent.jumpingAbility:
			return startJumpingState
		
		if event.is_action_pressed("dash") && parent.dash_points > 0:
			return dashingState
		
		if event.is_action_pressed("attack"):
			return attackingState
		
		if event.is_action_pressed("shoot"):
			return shootingState
		
		if event.is_action_pressed("reload"):
			return reloadingState
	
	return null

func process_frame(_delta: float) -> State:
	if Input.is_action_just_released("run"):
		return walkingState
	
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

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if !movement:
		return idleState
	
	#parent.player_sprite.flip_h = movement > 0
	
	if movement > 0:
		parent.player_sprite.scale.x = 1
		parent.dash_dir = Vector2.RIGHT
	else:
		parent.player_sprite.scale.x = -1
		parent.dash_dir = Vector2.LEFT
	
	if movement >= parent.runSpeed:
		parent.velocity.x = min(parent.velocity.x + acceleration, movement)
	else:
		parent.velocity.x = max(parent.velocity.x - acceleration, movement)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		coyote_timer.start()
		return fallingState
	
	return null
