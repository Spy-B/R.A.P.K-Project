extends CharacterBody2D
#@export_category("Player Abilities")

var motion := Vector2.ZERO

@export_group("Character")
@onready var spriteScaleX = $PlayerSprites.scale.x
@onready var spriteScaleY = $PlayerSprites.scale.y
var state_machine

@export var checkpoint_manager: Node

@export_group("Physics")
@export var gravity = 98

@export var max_speed := 600
@export var max_speed_in_water := 200

var playerIsInWater: bool

@export_range(0, 2) var timeScale: float = 1

@export var followLvlScaneTime := false

@export var PUSH_FORCE := 15
@export var MIN_PUSH_FORCE := 10

@export_group("Movement")
@export_placeholder("Animation") var idleAnimation: String

@export var canWalk := true
@export var walkingSpeed := 200
@export_placeholder("Animation") var walkingAnimation: String

@export var canRun := true
@export var runningSpeed: float = 500
@export_placeholder("Animation") var runningAnimation: String

@export var acceleration: float = 10
@export var movementWeight: float = 0.2

var dir := 1

@export_group("Jumping")
@export var canJump := true
@export var jumpPower := 1000
@export_placeholder("Animation") var jumpingAnimation: String
@export_placeholder("Animation") var fallingAnimation: String
@export_placeholder("Animation") var touchTheGroundAnimation: String

@export var canDoubleJump := true
var extraDoubleJumps := 1
@export var canTripleJump := false
var extraTripleJumps = 2
@export var canInfiniteJump := false
var isGrounded := true
var have_coyote := true

@export var jumpingWeight: float = 0.1

@export_group("Melee Attack")
@export var canAttack := true
@export var meleeCombo := true
@export var comboPoints := 3
@export var meleeComboCounter := true
@export_placeholder("Animation") var meleeAttackAnimation: String
var can_attack := true
var is_attack := false

@export_group("Shooting")
@export var canShoot := true
@export_placeholder("Animation") var shootingAnimation: String
@export_placeholder("Animation") var PowerfulShootAnimation: String
@export var bullet: PackedScene
@export var ammoInMag: int = Global.ammo_in_mag
@export var maxAmmo: int = Global.max_ammo
@export var extraAmmo: int = Global.extra_ammo

@export var InfiniteAmmo := false
@export var fireRate := 0.5
@export var reloadTime := 0.5
var can_reload := true
var can_fire := true
var is_shooting := false
@export var killComboCounter := true
var killCombo = Global.killComboCounter
@export var killComboTime := 1

@export_range(0, 2) var bulletTimeScale: float = 1

@export_group("Death")
@export var canDie := true
var isDie := false
@export var healthValue := 100
@export var deathAnimation: String

@export_group("Inventory Management System")
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI

@export var handgunMagazineSize: int
@export var IncreaseInventorySize_bag1: int

@export var Test := []

@export_group("Other")
@export_placeholder("Group") var enemiesGroup: String
@export_placeholder("Group") var NpcsGroup: String

@onready var reloadTimer = $Timers/ReloadTimer

@export var voidAreaGroup: String

var inConversation := false

@onready var health_bar = $UI/HealthBar/TextureProgressBar


# warning-ignore:export_hint_type_mistmatch
#export(String,"Rebecca", "Mary", "Leah") var array = 1
#
#onready var anim1 = $AnimationPlayer.play("Idle")
#export(int, "Idle", "Running", "Shooting") var animation
## Editor will enumerate with string names.
#export(String, "Rebecca", "Mary", "Leah") var character_name
#
#export(int, FLAGS, "Fire", "Water", "Earth", "Wind") var spell_elements = 0

@export var DASH_SPEED = 1200
@export var DASH_DURATION = 0.15
@export var DASH_COOLDOWN = 0.5
@export var PUSH = 100

var dashVector = Vector2.ZERO
var can_dash = true
var isDashing = false
var dashTimer = 0.0
var dashCooldownTimer = 0.0
var dir_x = 1


# Start function: Everything here starts at the first FRAME
func _ready():
	$PlayerSprites.scale.x = spriteScaleX
	$PlayerSprites.scale.y = spriteScaleY
	
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	$AnimationPlayer.speed_scale = timeScale
	
	$PlayerSprites/MeleeAttack2/CollisionShape2D.disabled = true
	
	$PlayerSprites/ShootingEffect.visible = false
	
	#$ComboTimer.wait_time = killComboTime
	#$ComboTimer.one_shot = true
	
	#	if spell_elements == 1 + 2 + 4 + 8:
	#		print("fire")
	Global.set_player_reference(self)
	
	Global.playerHealthValue = healthValue

# Update function: Everything here is updated 60 times per second
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if followLvlScaneTime:
		timeScale = Global.timeScale
	
	set_velocity(motion * timeScale)
	set_up_direction(Vector2.UP)
	#set_floor_stop_on_slope_enabled(false)
	#set_max_slides(4)
	#set_floor_max_angle(PI/4)
	move_and_slide()
	motion = velocity
	
	Gravity()
	State_Machine()
	
	# this Script for Exporting variabels
	if canWalk && !inventory_ui.visible && !Global.inConversation:
		walking()
	if canRun && !inventory_ui.visible && !Global.inConversation:
		running()
	if canJump && !inventory_ui.visible && !Global.inConversation:
		jumping()
	if canDoubleJump && canJump && !canTripleJump && !inventory_ui.visible:
		doubleJump()
	if canTripleJump && canJump && !inventory_ui.visible:
		tripleJump()
	if canInfiniteJump && !inventory_ui.visible:
		infiniteJumps()
	if canAttack && !meleeCombo && !inventory_ui.visible && !Global.inConversation:
		meleeAttack()
	if meleeCombo && !inventory_ui.visible:
		MeleeCombo()
	if canShoot && !inventory_ui.visible && !Global.inConversation:
		shooting()
		reload()
	if canDie && !inventory_ui.visible && !Global.inConversation:
		Death()
	
	Dash(delta)
	
	health_bar.value = Global.playerHealthValue
	
	#if killComboCounter && !inventory_ui.visible:
		#KillCombo()
		
	if InfiniteAmmo == true:
		ammoInMag = !0
	
	if Global.inConversation:
		interact_ui.visible = false
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			var push_force = (PUSH_FORCE * motion.length() / runningSpeed) + MIN_PUSH_FORCE
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused

#Gravity Function
func Gravity():
	if !is_on_floor():
		motion.y += gravity
		if have_coyote:
			$Timers/CoyoteTimer.start()
			have_coyote = false
	else:
		extraDoubleJumps = 1
		extraTripleJumps = 2
		have_coyote = true
	
	#if !Input.is_action_pressed("jumping") && motion.y < 0:
		#motion.y = lerp(motion.y,0,0.2)


func State_Machine():
	if is_on_floor() && canWalk && canRun && !is_attack  && !inventory_ui.visible && !Global.inConversation:
		$PlayerSprites/ShootingEffect.visible = false
		if (Input.is_action_pressed("ui_right") ||  Input.is_action_pressed("ui_left")) && !(Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_left")):
			state_machine.travel(walkingAnimation)
		
		else:
			state_machine.travel(idleAnimation)
		
		if motion.y < -gravity && !inventory_ui.visible:
			state_machine.travel(jumpingAnimation)
	
	else:
		$PlayerSprites/ShootingEffect.visible = false
		if motion.y < 0 && !inventory_ui.visible:
			state_machine.travel(jumpingAnimation)
		
		if motion.y > gravity && !inventory_ui.visible:
			state_machine.travel(fallingAnimation)
		
	if !isGrounded && is_on_floor():
		state_machine.travel(touchTheGroundAnimation)
		$Particles/JumpParticles.restart()
	
	isGrounded = is_on_floor()
	
	if  (Input.is_action_pressed("ui_right") ||  Input.is_action_pressed("ui_left")) && !(Input.is_action_pressed("ui_right") && Input.is_action_pressed("ui_left")) &&  Input.is_action_pressed("running") && is_on_floor() && !inventory_ui.visible && !Global.inConversation:# && (motion.x >= runningSpeed || motion.x <= -runningSpeed):
		$PlayerSprites/ShootingEffect.visible = false
		state_machine.travel(runningAnimation)
		$Particles/MoveParticles.emitting = true
	else:
		$Particles/MoveParticles.emitting = false
	
	if Global.playerHealthValue <= 0:
		state_machine.travel(deathAnimation)

#Walking Function
func walking():
	if canWalk && canRun && !is_attack:
		if Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
			#motion.x = walkingSpeed
			motion.x = min(motion.x + acceleration, walkingSpeed)
			dir = 1
			$PlayerSprites.scale.x = spriteScaleX
			
		elif Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
			#motion.x = -walkingSpeed
			motion.x = max(motion.x - acceleration, -walkingSpeed)
			dir = -1
			$PlayerSprites.scale.x = -spriteScaleX
			
		else:
			motion.x = lerp(motion.x, 0.0, movementWeight)

#Running Function
func running():
	if canWalk && canRun && !is_attack:
		if Input.is_action_pressed("ui_right") && Input.is_action_pressed("running") && !Input.is_action_pressed("ui_left"):
			motion.x = runningSpeed
			dir = 1
			#motion.x = min(motion.x + acceleration, runningSpeed)
			$PlayerSprites.scale.x = spriteScaleX
		
		elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("running") && !Input.is_action_pressed("ui_right"):
			motion.x = -runningSpeed
			dir = -1
			#motion.x = max(motion.x - acceleration, -runningSpeed)
			$PlayerSprites.scale.x = -spriteScaleX
		
	# this code make the player running using the walking input if the canWalking Variable is false
	elif !canWalk && canRun && !is_attack:
		if Input.is_action_pressed("ui_right") && !Input.is_action_pressed("ui_left"):
			motion.x = runningSpeed
			dir = 1
			#motion.x = min(motion.x + acceleration, runningSpeed)
			$PlayerSprites.scale.x = spriteScaleX
			
			
		elif Input.is_action_pressed("ui_left") && !Input.is_action_pressed("ui_right"):
			motion.x = -runningSpeed
			dir = -1
			#motion.x = max(motion.x - acceleration, -runningSpeed)
			$PlayerSprites.scale.x = -spriteScaleX
			
			
		else:
			motion.x = lerp(motion.x, 0.0, movementWeight)
	else:
		motion.x = lerp(motion.x, 0.0, movementWeight)

#Jumping Functions
func jumping():
	if Input.is_action_just_pressed("jumping"):
		$Timers/JumpBufferTimer.start()
	
	if (is_on_floor() || !$Timers/CoyoteTimer.is_stopped()) && (Input.is_action_just_pressed("jumping") || !$Timers/JumpBufferTimer.is_stopped()):
		motion.y = -jumpPower
		#if (Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_left")):
			#motion.x = 1000 * dir
		$Particles/JumpParticles.restart()
		$Timers/CoyoteTimer.stop()
		$Timers/JumpBufferTimer.stop()
	
	if !Input.is_action_pressed("jumping") && motion.y < 0:
		motion.y = lerp(motion.y, 0.0,jumpingWeight)

func doubleJump():
	if (Input.is_action_just_pressed("jumping") || !$Timers/JumpBufferTimer.is_stopped()) && !is_on_floor() && extraDoubleJumps > 0:
		motion.y = -jumpPower
		$Timers/JumpBufferTimer.stop()
		extraDoubleJumps -= 1
	
	if !Input.is_action_pressed("jumping") && motion.y < 0:
		motion.y = lerp(motion.y, 0.0,jumpingWeight)

func tripleJump():
	if Input.is_action_just_pressed("jumping") && !is_on_floor() && extraTripleJumps > 0:
		motion.y = -jumpPower
		extraTripleJumps -= 1
	
	if !Input.is_action_pressed("jumping") && motion.y < 0:
		motion.y = lerp(motion.y, 0.0,jumpingWeight)

func infiniteJumps():
	if Input.is_action_just_pressed("jumping"):
		motion.y = -jumpPower
	
	if !Input.is_action_pressed("jumping") && motion.y < 0:
		motion.y = lerp(motion.y, 0.0,jumpingWeight)

@warning_ignore("unused_parameter")
func Dash(delta):
	#@warning_ignore("unused_variable", "shadowed_variable_base_class")
	#var velocity = Vector2.ZERO
	#
	#if Input.is_action_just_pressed("Dashing") and not isDashing and dashCooldownTimer <= 0.0 && can_dash == true:
		#dashVector = Input.get_action_strength("ui_right") * Vector2.RIGHT
		#dashVector += Input.get_action_strength("ui_left") * Vector2.LEFT
		#dashVector += Input.get_action_strength("ui_down") * Vector2.DOWN
		#dashVector += Input.get_action_strength("ui_up") * Vector2.UP
		##$Squish/AnimatedSprite.play("Dash 2")
		#
##		if Input.is_action_just_pressed("ui_down") && is_on_floor():
##			get_parent().get_node("TileMapOne-Way/StaticBody2D/CollisionShape2D").disabled = true
##		else:
##			get_parent().get_node("TileMapOne-Way/StaticBody2D/CollisionShape2D").disabled = false
		#
		#if dashVector == Vector2.ZERO:
			#if dir_x == 1:
				#dashVector = Vector2.RIGHT
			#elif dir_x == -1:
				#dashVector = Vector2.LEFT
			#else:
				#dashVector = Vector2.ZERO
		#
		#if dashVector != Vector2.ZERO:
			#dashVector = dashVector.normalized()
			#isDashing = true
			#can_dash = false
			#dashTimer = DASH_DURATION
			#dashCooldownTimer = DASH_COOLDOWN
	#
	#if isDashing:
		#velocity = dashVector * DASH_SPEED
		#dashTimer -= delta
		#if dashTimer <= 0.0:
			#isDashing = false
	#
##	if !is_on_floor():
##		velocity.y += 1000 * delta
## warning-ignore:return_value_discarded
	#
	#if dashCooldownTimer > 0.0:
		#dashCooldownTimer -= delta
	
	pass

#Melee Attack Function
func meleeAttack():
	if Input.is_action_just_pressed("attack") && is_on_floor() && (!meleeCombo && canAttack && !is_attack):
		is_attack = true
		can_attack = false
		motion.x = 0
		state_machine.travel(meleeAttackAnimation)
		await $AnimationTree.animation_finished
		is_attack = false
		can_attack = true
		

#Melee Combo Function
func MeleeCombo():
	if Input.is_action_just_pressed("attack") && is_on_floor() && comboPoints == 3 && (canAttack && !is_attack):
		is_attack = true
		can_attack = false
		motion.x = 0
		state_machine.travel(meleeAttackAnimation)
		comboPoints = comboPoints - 1
		$Timers/MeleeComboTimer.start()
	
	elif Input.is_action_just_pressed("attack") && is_on_floor() && comboPoints == 2 && (canAttack && !is_attack):
		is_attack = true
		can_attack = false
		motion.x = 0
		#state_machine.travel(********)   you should call the Second ATTACK ANIMATION
		comboPoints = comboPoints - 1
		$Timers/MeleeComboTimer.start()

func _on_MeleeComboTimer_timeout():
	comboPoints = 3
	is_attack = false
	can_attack = true

func _on_MeleeAttack2_body_entered(body):
	if body.is_in_group(enemiesGroup):
		#body.queue_free()
		body.lifePoints -= 1

#Shooting Function
func shooting():
	var randomShootingAnimtion = 0 #randi_range(0, 2)
	if Input.is_action_pressed("shooting") && is_on_floor():
		if ammoInMag != 0:
			motion.x = 0
			if randomShootingAnimtion < 1:
				state_machine.travel(PowerfulShootAnimation)
			else:
				state_machine.travel(shootingAnimation)
		can_reload = false
		if can_fire && ammoInMag > 0:
			ammoInMag = ammoInMag - 1
			var bulletInstance = bullet.instantiate()
			
			bulletInstance.global_position = $PlayerSprites/GunBarrel.global_position
			bulletInstance.global_rotation = $PlayerSprites/GunBarrel.global_rotation
			bulletInstance.shooter = self
			bulletInstance.timeScale = bulletTimeScale
			get_parent().add_child(bulletInstance)
			state_machine.travel(shootingAnimation)
			can_fire = false
			await get_tree().create_timer(fireRate).timeout
			can_fire = true
		if !can_fire && ammoInMag == 0:
			reloadTimer.start()

# the reload script
func reload():
	reloadTimer.wait_time = reloadTime
	reloadTimer.one_shot = true
	
	if Input.is_action_just_pressed("reload"):
		can_fire = false
		reloadTimer.start()
	
	if ammoInMag == 0 && extraAmmo == 0:
		can_fire = false
		if ammoInMag == 0:
			can_fire = true
			reloadTimer.start()

func _on_reload_timer_timeout():
	var ammo_needed = (maxAmmo - ammoInMag)
	
	if ammoInMag == 0 && extraAmmo >= ammo_needed || ammoInMag < maxAmmo && extraAmmo != 0 && extraAmmo >= ammo_needed:
		extraAmmo -= ammo_needed
		ammoInMag += ammo_needed
		
	elif ammoInMag == 0 && extraAmmo < ammo_needed || extraAmmo < ammo_needed:
		ammoInMag += extraAmmo
		extraAmmo = 0
	
	can_fire = true

#func KillCombo():
	#if killCombo != 0:
		#get_parent().get_node("GUI/ComboCounter").visible = true
		#$Timers/ComboTimer.start()

func _on_ComboTimer_timeout():
	killCombo = 5

func Death():
	if isDie:
		global_position = checkpoint_manager.last_position
		await get_tree().create_timer(0.05).timeout
		Respawn()

func _on_damage_area_area_entered(area):
	if area.is_in_group(voidAreaGroup):
		Respawn()

func Respawn():
	global_position = checkpoint_manager.last_position
	isDie = false
	Global.playerHealthValue = healthValue

# Apply the effect of the item
func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			runningSpeed += Test[0][1]
			print("Speed increased to ", runningSpeed)
		"Handgun Mag":
			extraAmmo += handgunMagazineSize
		"Double Jump":
			canDoubleJump = true
		"Health":
			Global.playerHealthValue += 20
		"Slot Boost":
			Global.increase_inventory_size(IncreaseInventorySize_bag1)
			print("Slots increased to ", Global.inventory.size())
		_:
			print("There is no effect for this item")

func in_water():
	@warning_ignore("integer_division")
	gravity = gravity / 3
	max_speed = max_speed_in_water

#func is_in_water():
	#pass

func _on_np_cs_detector_body_entered(body):
	if body.is_in_group(NpcsGroup):
		body.playerIsNearby = true
		interact_ui.visible = true
	
	#if body.conversationStarted && !body.conversationEnded:
		#inConversation = true
	#elif !body.conversationStarted && body.conversationEnded:
		#inConversation = false

func _on_np_cs_detector_body_exited(body):
	if body.is_in_group(NpcsGroup):
		body.playerIsNearby = false
		interact_ui.visible = false
	
	#if body.conversationStarted && !body.conversationEnded:
		#inConversation = true
	#elif !body.conversationStarted && body.conversationEnded:
		#inConversation = false
