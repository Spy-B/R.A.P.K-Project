extends State

@export var idleState: State
@export var runningState: State
@export var fallingState: State
@export var deathState: State

func enter() -> void:
	#parent.player_sprite.material.shader_parameter("flashValue", 1.0)
	pass

func process_frame(_delta: float) -> State:
	if !parent.just_respawn:
		parent.health_bar_tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		parent.health_bar_tween.tween_property(parent.ui.health_bar, "value", parent.health, 0.05)
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if parent.is_on_floor():
		if movement:
			return runningState
		else:
			return idleState
	else:
		return fallingState
	
	#return null
