extends State

var finished_animations: Array = []


func enter() -> void:
	print("[State] -> Shooting")
	super()
	
	parent.runtime_vars.p_n_s_p = false
	finished_animations.clear()
	
	if parent.ammoInMag > 0 && parent.runtime_vars.can_fire:
		shooting()

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		#if event.is_action_pressed("attack") && parent.attackingAbility:
			#parent.a_n_s_p = true
		
		if event.is_action_pressed("shoot") && !parent.autoShoot:
			parent.runtime_vars.p_n_s_p = true
	
	return null

func process_frame(_delta: float) -> State:
	#if parent.a_n_s_p && finished_animations.has(1):
		#return attackingState
	
	if Input.is_action_pressed("shoot") && parent.autoShoot:
		parent.runtime_vars.p_n_s_p = true
	
	if parent.runtime_vars.p_n_s_p && finished_animations.has(1) && parent.runtime_vars.can_fire:
		enter()
	
	
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
	return null

func process_physics(delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	parent.velocity.x = movement
	
	if !parent.is_on_floor():
		parent.velocity.y += parent.gravity * delta
	else:
		if !parent.runtime_vars.can_fire && !parent.runtime_vars.p_n_s_p && finished_animations.has(1):
			if parent.ammoInMag <= 0:
				return parent.reloadingState
			
			if !movement:
				return parent.idleState
			elif movement:
				return parent.walkingState
	
	parent.move_and_slide()
	
	return null

func shooting() -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	var bullet: Area2D = parent.bulletScene.instantiate()
	
	bullet.dir = dir
	bullet.global_position = gun_barrel.global_position
	bullet.global_rotation = gun_barrel.global_rotation
	bullet.shooter = parent
	parent.get_parent().add_child(bullet)
	
	if !parent.infiniteAmmo:
		parent.ammoInMag -= 1
	
	# fire rate functionality
	parent.runtime_vars.can_fire = false
	await get_tree().create_timer(parent.shootingTime, true, true).timeout
	parent.runtime_vars.can_fire = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animationName:
		finished_animations.append(1)
