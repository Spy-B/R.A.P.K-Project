extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var shootingState: State
@export var damagingState: State
@export var deathState: State

@export_group("Animations")
@export_placeholder("Animation") var comboAttack2: String
@export_placeholder("Animation") var comboAttack3: String
@export_placeholder("Animation") var shooting: String

@export var attackDamage: int = 25

var finished_animations: Array = []

@onready var quit_state_timer: Timer = $"../../Timers/MeleeComboTimer"
var timeout: bool = false

@export var target: String


func enter() -> void:
	super()
	
	parent.combo_points = 2
	finished_animations.clear()
	
	parent.a_n_s_p = false
	timeout = false
	quit_state_timer.start()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed(attackingInput) && !timeout:
		parent.a_n_s_p = true
		quit_state_timer.start()
	
	#if Input.is_action_just_pressed(shootingInput) && !timeout:
		#parent.a_n_s_p = true
	
	return null

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	if parent.health <= 0:
		return deathState
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	
	if movement:
		if movement > 0:
			parent.player_sprite.scale.x = 1
		else:
			parent.player_sprite.scale.x = -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	if parent.a_n_s_p:
		if finished_animations.has(1) && parent.combo_points == 2:
			animation.play(comboAttack2)
			parent.combo_points -= 1
			#NOTE Remove the "a_n_s_p = false" if you gonna add a new Combo Attack 👇
			parent.a_n_s_p = false
		
		elif finished_animations.has(2) && parent.combo_points == 1:
			animation.play(comboAttack3)
			parent.combo_points -= 1
			#NOTE You should add "a_n_s_p = false" here 👇.
			#NOTE Don't forget to add one more point to the "parent.combo_points" (you must update it in the enter() function 👆 also)
		
		#else:
			#return shootingState
		
	else:
		if timeout:
			if !movement && parent.is_on_floor():
				return idleState
			return runningState
	
	return null

func _on_melee_combo_timer_timeout() -> void:
	timeout = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == animationName:
		finished_animations.append(1)
	
	elif anim_name == comboAttack2:
		finished_animations.append(2)
	
	elif anim_name == comboAttack3:
		#Nt Use if you wanna add a New Combo Attack!
			#finished_animations.append(3)
		parent.a_n_s_p = false
		timeout = true


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(target):
		body.health -= attackDamage
		body.damaged = true
		body.damage_value = attackDamage
		parent.combo_fight_points += 1
		print("[Enemy] -> [Health]: ", attackDamage)
