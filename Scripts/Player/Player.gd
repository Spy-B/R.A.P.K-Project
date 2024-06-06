extends CharacterBody2D

var motion = Vector2.ZERO

@export_group("Character")
@onready var spriteScaleX = $PlayerSprites.scale.x
@onready var spriteScaleY = $PlayerSprites.scale.y
var state_machine


@export_group("Physics")
@export var gravity = 98

@export_group("Movement")
@export var canWalk = true
@export var walkingSpeed = 200
@export_placeholder("Animation") var idleAnimation: String
@export_placeholder("Animation") var walkingAnimation: String
@export var canRun = true
@export var runningSpeed = 500
@export_placeholder("Animation") var runningAnimation: String

@export_group("Jumping")
@export var canJump = true
@export var jumpPower = 1000
@export_placeholder("Animation") var jumpingAnimation: String
@export_placeholder("Animation") var fallingAnimation: String
@export_placeholder("Animation") var touchTheGroundAnimation: String
@export var canDoubleJump = true
var extraDoubleJumps = 1
@export var canTripleJump = false
var extraTripleJumps = 2
@export var canInfiniteJump = false
var isGrounded = true
var have_coyote = true

@export_group("Melee Attack")
@export var canAttack = true
@export var meleeCombo = true
@export var comboPoints = 3
@export var meleeComboCounter = true
@export_placeholder("Animation") var meleeAttackAnimation: String
var can_attack = true

@export_group("Shooting")
@export var canShoot = true
@export_placeholder("Animation") var shootingAnimation: String
@export_placeholder("Animation") var PowerfulShootAnimation: String
@export var bullet: PackedScene
@export var ammoInMag: int = Global.ammo_in_mag
@export var maxAmmo: int = Global.max_ammo
@export var extraAmmo: int = Global.extra_ammo

@export var InfiniteAmmo = false
@export var fireRate = 0.5
@export var reloadTime = 0.5
var can_reload = true
var can_fire = true
var is_shooting = false
@export var killComboCounter = true
var killCombo = Global.killComboCounter
@export var killComboTime = 1

@export_group("Inventory Management System")
@onready var interact_ui = $interactUI
@onready var inventory_ui = $InventoryUI

@export_group("Other")
@export_placeholder("Group") var playerGroup: String
@export_placeholder("Group") var enemiesGroup: String

@onready var reloadTimer = $Timers/ReloadTimer

# warning-ignore:export_hint_type_mistmatch
#export(String,"Rebecca", "Mary", "Leah") var array = 1
#
#onready var anim1 = $AnimationPlayer.play("Idle")
#export(int, "Idle", "Running", "Shooting") var animation
## Editor will enumerate with string names.
#export(String, "Rebecca", "Mary", "Leah") var character_name
#
#export(int, FLAGS, "Fire", "Water", "Earth", "Wind") var spell_elements = 0




# Start function: Everything here starts at the first FRAME
func _ready():
	$PlayerSprites.scale.x = spriteScaleX
	$PlayerSprites.scale.y = spriteScaleY
	
	state_machine = $AnimationTree.get("parameters/playback")
	$AnimationTree.active = true
	
	$PlayerSprites/MeleeAttack2/CollisionShape2D.disabled = true
	
	#$ComboTimer.wait_time = killComboTime
	#$ComboTimer.one_shot = true
	
	#	if spell_elements == 1 + 2 + 4 + 8:
	#		print("fire")
	
	self.add_to_group(playerGroup)
	Global.set_player_reference(self)

# Update function: Everything here is updated 60 times per second
@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	Gravity()
	State_Machine()
	
	# this Script for Exporting variabels
	if canWalk:
		walking()
	if canRun:
		running()
	if canJump:
		jumping()
	if canDoubleJump && canJump && !canTripleJump:
		doubleJump()
	if canTripleJump && canJump:
		tripleJump()
	if canInfiniteJump:
		infiniteJumps()
	if canAttack && !meleeCombo:
		meleeAttack()
	if meleeCombo:
		MeleeCombo()
	if canShoot:
		shooting()
		reload()
			
	if killComboCounter:
		KillCombo()
		
	if InfiniteAmmo == true:
		ammoInMag = !0

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
	
	if isGrounded == false && is_on_floor() == true:
		state_machine.travel(touchTheGroundAnimation)
		$Particles/JumpParticles.restart()
	
	isGrounded = is_on_floor()


func State_Machine():
	if is_on_floor():
		if (motion.x == walkingSpeed || motion.x == -walkingSpeed):
			state_machine.travel(walkingAnimation)
		
		if motion.x == 0:
			state_machine.travel(idleAnimation)
		
		if motion.y < -gravity:
			state_machine.travel(jumpingAnimation)
	
	else:
		if motion.y < 0:
			state_machine.travel(jumpingAnimation)
		
		if motion.y > gravity:
			state_machine.travel(fallingAnimation)
		
	#if Input.is_action_pressed("shooting"):
		#animation_tree.travel("Shooting")
	
	if (motion.x == runningSpeed || motion.x == -runningSpeed) && is_on_floor():
		state_machine.travel(runningAnimation)
		$Particles/MoveParticles.emitting = true
	else:
		$Particles/MoveParticles.emitting = false

#Walking Function
func walking():
	if canWalk && canRun:
		if Input.is_action_pressed("ui_right"):
			motion.x = walkingSpeed
			$PlayerSprites.scale.x = spriteScaleX
			
		elif Input.is_action_pressed("ui_left"):
			motion.x = -walkingSpeed
			$PlayerSprites.scale.x = -spriteScaleX
			
		else:
			motion.x = 0

#Running Function
func running():
	if canWalk && canRun:
		if Input.is_action_pressed("ui_right") && Input.is_action_pressed("running"):
			motion.x = runningSpeed
			$PlayerSprites.scale.x = spriteScaleX
			
			
		elif Input.is_action_pressed("ui_left") && Input.is_action_pressed("running"):
			motion.x = -runningSpeed
			$PlayerSprites.scale.x = -spriteScaleX
			
	# this code make the player running using the walking input if the canWalking Variable is false
	elif !canWalk && canRun:
		if Input.is_action_pressed("ui_right"):
			motion.x = runningSpeed
			$PlayerSprites.scale.x = spriteScaleX
			
			
		elif Input.is_action_pressed("ui_left"):
			motion.x = -runningSpeed
			$PlayerSprites.scale.x = -spriteScaleX
			
			
		else:
			motion.x = 0
	else:
		motion.x = 0

#Jumping Functions
func jumping():
	if Input.is_action_just_pressed("jumping"):
		$Timers/JumpBufferTimer.start()
	
	if (is_on_floor() || !$Timers/CoyoteTimer.is_stopped()) && (Input.is_action_just_pressed("jumping") || !$Timers/JumpBufferTimer.is_stopped()):
		motion.y = -jumpPower
		$Particles/JumpParticles.restart()
		$Timers/CoyoteTimer.stop()
		$Timers/JumpBufferTimer.stop()

func doubleJump():
	if (Input.is_action_just_pressed("jumping") || !$Timers/JumpBufferTimer.is_stopped()) && !is_on_floor() && extraDoubleJumps > 0:
		motion.y = -jumpPower
		$Timers/JumpBufferTimer.stop()
		extraDoubleJumps -= 1

func tripleJump():
	if Input.is_action_just_pressed("jumping") && !is_on_floor() && extraTripleJumps > 0:
		motion.y = -jumpPower
		extraTripleJumps -= 1

func infiniteJumps():
	if Input.is_action_just_pressed("jumping"):
		motion.y = -jumpPower

#Melee Attack Function
func meleeAttack():
	if Input.is_action_just_pressed("attack") && is_on_floor() && !meleeCombo:
		#can_attack = false
		motion.x = 0
		state_machine.travel(meleeAttackAnimation)
		await $AnimationPlayer.animation_finished
		#can_attack = true
		

#Melee Combo Function
func MeleeCombo():
	if Input.is_action_just_pressed("attack") && is_on_floor() && comboPoints == 3:
		state_machine.travel(meleeAttackAnimation)
		comboPoints = comboPoints - 1
		$Timers/MeleeComboTimer.start()
	
	elif Input.is_action_just_pressed("attack") && is_on_floor() && comboPoints == 2:
		$AnimationPlayer.play("Attack 2")
		comboPoints = comboPoints - 1
		$Timers/MeleeComboTimer.start()

func _on_MeleeComboTimer_timeout():
	comboPoints = 3

func _on_MeleeAttack2_body_entered(body):
	if body.is_in_group(enemiesGroup):
		#body.queue_free()
		body.lifePoints -= 0.5

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

func KillCombo():
	if killCombo != 0:
		get_parent().get_node("GUI/ComboCounter").visible = true
		$Timers/ComboTimer.start()

func _on_ComboTimer_timeout():
	killCombo = 5
