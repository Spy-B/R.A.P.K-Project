extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var reloadingState: State
@export var damagingState: State
@export var deathState: State

var finished_animations: Array = []


func enter() -> void:
	parent.a_n_s_p = false
	finished_animations.clear()
	
	if parent.ammoInMag > 0 && parent.shootingAbility:
		shooting()


func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		#if event.is_action_pressed("attack") && parent.attackingAbility:
			#parent.a_n_s_p = true
		
		if event.is_action_pressed("shoot"): # && !parent.autoShoot:
			parent.a_n_s_p = true
	
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	if parent.health <= 0:
		return deathState
	
	
	#if parent.a_n_s_p && finished_animations.has(1):
		#return attackingState
	
	#if Input.is_action_pressed("shoot") && parent.autoShoot:
		#parent.a_n_s_p = true
	
	# FIX the Animation freezes sometimes
	if parent.a_n_s_p && finished_animations.has(1) && parent.can_fire:
		enter()
	
	if parent.ammoInMag <= 0:
		return reloadingState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	
	#if movement:
		#if movement > 0:
			#parent.player_sprite.scale.x = 1
		#else:
			#parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if !animation.is_playing() && !parent.a_n_s_p:
		if !movement && parent.is_on_floor():
			return idleState
		return runningState
	
	return null

func shooting() -> void:
	if parent.can_fire:
		animation.play(animationName)
		
		var dir: float = Input.get_axis("move_left", "move_right")
		var bullet: Area2D = parent.bulletScene.instantiate()
		
		bullet.dir = dir
		bullet.global_position = gun_barrel.global_position
		bullet.global_rotation = gun_barrel.global_rotation
		bullet.shooter = parent
		parent.ammoInMag -= 1
		parent.get_parent().add_child(bullet)
		
		# fire rate functionality
		parent.can_fire = false
		await get_tree().create_timer(parent.shootingTime, true, true).timeout
		parent.can_fire = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animationName:
		finished_animations.append(1)
		#parent.a_n_s_p = false
