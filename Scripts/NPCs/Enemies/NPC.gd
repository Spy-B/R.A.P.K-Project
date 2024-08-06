extends CharacterBody2D

var motion := Vector2.ZERO

@export_group("Character")
enum Types {Friendly, Enemey}
@export var NPCTypes: Types

enum Modes {WanderingAround ,Searching, Attacking, Death}
@export var NPCModes: Modes

@export_group("Physics")
@export var gravity = 98
@export var max_speed := 600
@export var max_speed_in_water := 200

@export_range(0, 2) var timeScale: float = 1

@export_group("Movement")
@export var idleAnimation: String
@export var canMove := true
@export var runningSpeed := 100
@export var runningAnimation: String

var standing = true
var movingRight = false
var movingLeft = false
var dir = 1

enum lookingDirs {Right, Left}
@export var lookingDir: lookingDirs

@export_group("Attack")
@export var canAttack := true
@export var attackAnimation: String

@export_group("Shooting")
@export var canShoot := true
@export_placeholder("Animation") var shootingAnimation: String
@export_placeholder("Animation") var PowerfulShootAnimation: String
@export var bullet: PackedScene
@export var ammoInMag: int = Global.enemy_ammo_in_mag
@export var maxAmmo: int = Global.enemy_max_ammo
@export var extraAmmo: int = Global.enemy_extra_ammo

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

@export_group("Damage")
@export var hitAnimation: String

@export_group("Death")
@export var canDie := true
@export var isDie := false
@export var lifePoints: float = Global.enemiesLifePoints
@export var deadAnimation: String

@export_group("Dialogue System")
var playerName: String = "SCARLET"

@export var dialogueFile: JSON
var state := {
	"playerName": playerName,
	"NpcName": "JONE"
}

var playerIsNearby :=  false
var inConversation := false

@export_group("Other")
@export var player: CharacterBody2D
@export var lvlScene: String
@export var followLvlSceneTime := true

@export var playerGroup: String
@export var enemiesGroup: String
@export var npcsGroup: String
var sawPlayer := false
var isLookingForPlayer := false
var isAttacking := false


@onready var animation_player = $AnimationPlayer
@onready var enemy_sprites = $EnemySprites
@onready var spriteScaleX = enemy_sprites.scale.x
@onready var spriteScaleY = enemy_sprites.scale.y
var isGrounded := true
@onready var ray_cast_2d = $EnemySprites/RayCast2D
@onready var collision_shape_2d = $EnemySprites/PlayerDetector/CollisionShape2D
@onready var reloadTimer = $Timers/ReloadTimer
@onready var dialogue_ui = $DialogueUI
@onready var dialogue_box = $DialogueUI/DialogueBox
@onready var ez_dialogue = $DialogueUI/DialogueBox/EzDialogue
@onready var timer = $DialogueUI/DialogueBox/Timer
@onready var marker_2d = $EnemySprites/Marker2D


func _ready():
	isDie = false
	
	if lookingDir == 0:
		enemy_sprites.scale.x = spriteScaleX
	elif lookingDir == 1:
		enemy_sprites.scale.x = -spriteScaleX
	
	enemy_sprites.material = enemy_sprites.material.duplicate(true)

@warning_ignore("unused_parameter")
func _process(delta):
	if Input.is_action_pressed("interact"):
		if playerIsNearby:
			Global.inConversation = true
			player.global_position = marker_2d.global_position
			player.motion.x = 0
			set_process(false)
			timer.start()
	
	start_dialogue()

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if followLvlSceneTime:
		timeScale = Global.timeScale
	
	set_velocity(motion * timeScale)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	Gravity()
	
	if NPCTypes == 0:
		Friendly()
		add_to_group(npcsGroup)
	elif NPCTypes == 1:
		Enemy()
		add_to_group(enemiesGroup)
	
	if ray_cast_2d.get_collider() == player:
		isAttacking = true
		@warning_ignore("int_as_enum_without_cast")
		NPCModes = 2
	else:
		@warning_ignore("int_as_enum_without_cast")
		NPCModes = 0
		isAttacking = false
	
	if sawPlayer:
		lookAtPlayer()
	
	if isLookingForPlayer && !isAttacking:
		Searching()
	
	if !isLookingForPlayer:
		motion.x = 0
	
	if isAttacking:
		@warning_ignore("int_as_enum_without_cast")
		NPCModes = 2

func Gravity():
	if !is_on_floor():
		motion.y += gravity
	else:
		if isDie:
			gravity = 0
			$CollisionShape2D.disabled = true

func Friendly():
	if NPCModes == 0:
		Moving()
	
	lookAtPlayer()
	
	ray_cast_2d.enabled = false
	collision_shape_2d.disabled = true

func Enemy():
	if lifePoints == 0:
		@warning_ignore("int_as_enum_without_cast")
		NPCModes = 3
	
	if NPCModes == 0:
		Moving()
	
	elif NPCModes == 1:
		Searching()
	
	elif NPCModes == 2:
		Attack()
		Shooting()
	
	elif NPCModes == 3:
		Death()


func Moving():
	if motion.x == 0:
		animation_player.play(idleAnimation)
	else:
		animation_player.play(runningAnimation)
	
	animation_player.speed_scale = timeScale

func Wandering_around():
	#var change_move_timer = randf_range(0.5, 5)
	#
	#if standing:
		#!movingLeft
		#!movingRight
		#motion.x = 0
	#
	#elif movingRight:
		#!standing
		#!movingLeft
		#motion.x = runningSpeed * dir
	#
	#elif movingLeft:
		#!standing
		#!movingRight
		#motion.x = runningSpeed * dir
	pass

func lookAtPlayer():
	# TODO Improve the collision shape Size whene he see the player
	var direction = (player.global_position - global_position).normalized()
	
	# Make the enemy look at the player
	if lookingDir == 0:
		if direction.x > 0:
			dir = 1
			enemy_sprites.scale.x = spriteScaleX  # Flip sprite horizontally if player is to the left
		else:
			dir = -1
			enemy_sprites.scale.x = -spriteScaleX   # Flip sprite back if player is to the right
	
	elif lookingDir == 1:
		if direction.x < 0:
			dir = -1
			enemy_sprites.scale.x = -spriteScaleX  # Flip sprite horizontally if player is to the left
		else:
			dir = 1
			enemy_sprites.scale.x = spriteScaleX   # Flip sprite back if player is to the right

func Searching():
	motion.x = runningSpeed * dir

func Attack():
	motion.x = 0

#Shooting Function
func Shooting():
	if isAttacking && is_on_floor():
		if ammoInMag != 0:
			motion.x = 0
		can_reload = false
		if can_fire && ammoInMag > 0:
			ammoInMag = ammoInMag - 1
			var bulletInstance = bullet.instantiate()
			
			bulletInstance.global_position = $EnemySprites/GunBarrel.global_position
			bulletInstance.global_rotation = $EnemySprites/GunBarrel.global_rotation
			bulletInstance.shooter = self
			bulletInstance.timeScale = bulletTimeScale
			get_parent().add_child(bulletInstance)
			animation_player.play(attackAnimation)
			can_fire = false
			await get_tree().create_timer(fireRate).timeout
			can_fire = true
		if !can_fire && ammoInMag == 0:
			reloadTimer.start()

# the reload script
func reload():
	reloadTimer.wait_time = reloadTime
	reloadTimer.one_shot = true
	
	#if Input.is_action_just_pressed("reload"):
		#can_fire = false
		#reloadTimer.start()
	
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

func _on_player_detector_body_entered(body):
	if body.is_in_group(playerGroup):
		if NPCTypes == 1:
			isLookingForPlayer = true
		sawPlayer = true

func _on_player_detector_body_exited(body):
	if body.is_in_group(playerGroup):
		if NPCTypes == 1:
			sawPlayer = false
			isLookingForPlayer = false

@warning_ignore("unused_parameter")
func _on_attack_area_body_entered(body):
	pass

func applyDamage():
	var tween = get_tree().create_tween()
	tween.tween_method(set_flashShader, 1.0, 0.0, 0.15)

func set_flashShader(newValue: float):
	enemy_sprites.material.set_shader_parameter("flashValue", newValue)

func Death():
	sawPlayer = false
	isLookingForPlayer = false
	isAttacking = false
	
	animation_player.play(deadAnimation)
	gravity = 0
	$CollisionShape2D.disabled = true
	
	if isDie:
		ray_cast_2d.enabled = false
		queue_free()

func start_dialogue():
	if playerIsNearby && Global.inConversation:
		dialogue_ui.visible = true
		(ez_dialogue as EzDialogue).start_dialogue(dialogueFile, state)
	elif !playerIsNearby || !Global.inConversation:
		dialogue_ui.visible = false

func _on_ez_dialogue_custom_signal_received(value):
	if value == "endConversation":
		Global.inConversation = false
		set_process(true)

func _on_ez_dialogue_dialogue_generated(response):
	dialogue_box.clear_dialogue_box()
	dialogue_box.add_text(response.text)

func in_water():
	@warning_ignore("integer_division")
	gravity = gravity / 3
	max_speed = max_speed_in_water
