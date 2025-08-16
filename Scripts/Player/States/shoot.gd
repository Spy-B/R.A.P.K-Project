extends State

var finished_animations: Array = []
var input_cooldown: bool = false


func enter() -> void:
	print("[State] -> Shooting")
	
	if parent.ammoInMag > 0 && parent.runtime_vars.can_fire:
		parent.runtime_vars.shoot_queued = false
		parent.runtime_vars.p_n_t_s_p = false
		finished_animations.clear()
		super()
		shooting()
		
		input_cooldown = true
		get_tree().create_timer(0.1).timeout.connect(func() -> void: input_cooldown = false)

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("shoot") && !parent.autoShoot:
			parent.runtime_vars.shoot_queued = true
		
		if event.is_action_pressed("attack") && parent.attackingAbility:
			parent.runtime_vars.p_n_t_s_p = true
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
	
	if parent.ammoInMag <= 0 && finished_animations.has(1):
		return parent.reloadingState
	
	if Input.is_action_pressed("shoot") && parent.autoShoot && !input_cooldown:
		parent.runtime_vars.shoot_queued = true
	
	if parent.runtime_vars.shoot_queued && finished_animations.has(1):
		enter()
	
	if parent.runtime_vars.p_n_t_s_p && finished_animations.has(1):
		return parent.attackingState
	
	return null

func process_physics(delta: float) -> State:
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	parent.velocity.x = movement
	
	if !parent.is_on_floor():
		parent.velocity.y += parent.gravity * delta
	else:
		if !parent.runtime_vars.can_fire && !parent.runtime_vars.shoot_queued && !parent.runtime_vars.p_n_t_s_p && finished_animations.has(1):
			if parent.ammoInMag <= 0:
				return parent.reloadingState
	
	
	if !parent.runtime_vars.shoot_queued && parent.ammoInMag > 0 && finished_animations.has(1):
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
	get_tree().create_timer(parent.shootingTime).timeout.connect(func() -> void: parent.runtime_vars.can_fire = true)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animationName:
		finished_animations.append(1)
