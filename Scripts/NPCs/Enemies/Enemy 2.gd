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

@export_group("Attack")
@export var canAttack := true
@export var attackAnimation: String

@export_group("Death")
@export var canDie := true
@export var isDie := false
@export var lifePoints: float = Global.enemiesLifePoints
@export var deadAnimation: String

@export_group("Other")
@export var player: CharacterBody2D
@export var lvlScene: String
@export var followLvlSceneTime := true

@export var playerGroup: String
@export var sawPlayer := false


@onready var animation_player = $AnimationPlayer
@onready var enemy_sprites = $EnemySprites
@onready var spriteScaleX = enemy_sprites.scale.x
@onready var spriteScaleY = enemy_sprites.scale.y
var isGrounded := true
@onready var ray_cast_2d = $EnemySprites/RayCast2D


func _ready():
	isDie = false

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
	elif NPCTypes == 1:
		Enemy()
	
	if sawPlayer:
		lookAtPlayer()

func Gravity():
	if !is_on_floor():
		motion.y += gravity
	else:
		if isDie:
			gravity = 0
			$CollisionShape2D.disabled = true

func Friendly():
	if NPCModes:
		Moving()

func Enemy():
	if ray_cast_2d.get_collider() == player:
		sawPlayer = true
		NPCModes = 2
	else:
		NPCModes = 0
	
	if lifePoints == 0:
		NPCModes = 3
	
	if NPCModes == 0:
		Moving()
	
	elif NPCModes == 1:
		Searching()
	
	elif NPCModes == 2:
		Attack()
	
	elif NPCModes == 3:
		Death()


func Moving():
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
	
	if motion.x == 0:
		animation_player.play(idleAnimation)
	else:
		animation_player.play(runningAnimation)
	
	animation_player.speed_scale = timeScale

func lookAtPlayer():
	var direction = (player.global_position - global_position).normalized()
	
	if !isDie:
		# Make the enemy look at the player
		if direction.x < 0:
			dir = -1
			enemy_sprites.scale.x = -spriteScaleX  # Flip sprite horizontally if player is to the left
		else:
			dir = 1
			enemy_sprites.scale.x = spriteScaleX   # Flip sprite back if player is to the right

func Searching():
	pass

func Attack():
	animation_player.play(attackAnimation)
	
	lookAtPlayer()

@warning_ignore("unused_parameter")
func _on_attack_area_body_entered(body):
	pass

func Death():
	animation_player.play(deadAnimation)
		#if is_on_floor():
			#gravity = 0
			#$CollisionShape2D.disabled = true
		#else:
			#gravity = 98
			#$CollisionShape2D.disabled = false
	
	if isDie:
		ray_cast_2d.enabled = false
		queue_free()

func in_water():
	@warning_ignore("integer_division")
	gravity = gravity / 3
	max_speed = max_speed_in_water
