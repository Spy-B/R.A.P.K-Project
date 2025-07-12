extends State

@export var idleState: State
#@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var reloadingState: State
@export var deathState: State

func enter() -> void:
	super()
	parent.start_dialogue = true
	parent.ui.interact_key.visible = false
	
	await get_tree().create_timer(0.1).timeout
	
	if parent.npc_you_talk_to != null:
		var npc_pos: Vector2 = (parent.npc_you_talk_to.global_position - parent.global_position).normalized()
		checking_direction(npc_pos)
	#else:
		#return

func process_input(_input: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	if !parent.is_in_dialogue:
		return idleState
	
	return null

func process_physics(_delta: float) -> State:
	return null

func checking_direction(target_position: Vector2) -> void:
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	if target_position > Vector2(0, 0):
		parent.player_sprite.scale.x = 1
		tween.tween_property(parent.camera, "drag_horizontal_offset",  0.1, 0.8)
	
	elif target_position < Vector2(0, 0):
		parent.player_sprite.scale.x = -1
		tween.tween_property(parent.camera, "drag_horizontal_offset",  -0.1, 0.8)
