extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var reloadingState: State
@export var deathState: State

@export var arrowScene = PackedScene.new()

var finished_animations: Array = []

var reload: bool = false

func enter() -> void:
	super()
	
	parent.a_n_s_p = false
	reload = false
	
	var dir = Input.get_axis("move_left", "move_right")
	
	if parent.ammoInMag > 0:
		var arrow = arrowScene.instantiate()
		arrow.dir = dir
		arrow.global_position = gun_barrel.global_position
		arrow.global_rotation = gun_barrel.global_rotation
		arrow.shooter = parent
		parent.ammoInMag -= 1
		parent.get_parent().add_child(arrow)

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(shootingInput) && parent.is_on_floor():
		parent.a_n_s_p = true
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement = Input.get_axis("move_left", "move_right") * 20
	
	#if movement:
		#if movement > 0:
			#parent.player_sprite.scale.x = 1
		#else:
			#parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.a_n_s_p && finished_animations.has(1):
		animation.play(animationName)
	
	if !animation.is_playing() && !parent.a_n_s_p:
		if !movement && parent.is_on_floor():
			return idleState
		return runningState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.health <= 0:
		return deathState
	
	if !parent.ammoInMag:
		return reloadingState
	
	return null

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animationName:
		finished_animations.append(1)
		parent.a_n_s_p = false
