extends State

@export var comboAttacks: Array[String] = []
@export var attackDamage: int = 25

@onready var quit_state_timer: Timer = $"../../Timers/QuitStateTimer"
var timeout: bool = false
var current_attack_index: int = 0


func enter() -> void:
	print("[State] -> Attacking")
	
	current_attack_index = 0
	parent.runtime_vars.attack_queued = false
	timeout = false
	
	if comboAttacks.size() > 0:
		animation.play(comboAttacks[0])
	else:
		super()
	
	quit_state_timer.start()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack") && !timeout:
		parent.runtime_vars.attack_queued = true
		quit_state_timer.start()
	
	if event.is_action_pressed("shoot") && parent.shootingAbility && !timeout:
		parent.runtime_vars.shoot_queued = true
		quit_state_timer.start()
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	if parent.health <= 0:
		return parent.deathState
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	
	if movement != 0:
		parent.player_sprite.scale.x = 1 if movement > 0 else -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	
	if timeout:
		if !movement && parent.is_on_floor():
			return parent.idleState
		return parent.runningState
	
	return null


func _on_melee_combo_timer_timeout() -> void:
	timeout = true

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if parent.runtime_vars.attack_queued && current_attack_index < comboAttacks.size() - 1:
		current_attack_index += 1
		animation.play(comboAttacks[current_attack_index])
		parent.runtime_vars.attack_queued = false
		quit_state_timer.start()
	else:
		timeout = true

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(parent.enemyGroup):
		body.health -= attackDamage
		body.damaged = true
		body.damage_value = attackDamage
		parent.combo_fight_points += 1
		print("[Enemy] -> [Health]: ", attackDamage)
