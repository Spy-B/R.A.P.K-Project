extends CharacterBody2D

var motion = Vector2.ZERO

@export var gravity = 98

@export_group("Movement")
@export var canMove = true
@export var runningSpeed = 100
var isMovingLeft = true
var dir = 1

@export_group("Attack")
@export var canAttack = true
@export var lifePoints: float = Global.enemiesLifePoints
@export var deadAnimation: String
@export var isDie = false

@onready var enemy_sprites = $EnemySprites
@onready var spriteScaleX = enemy_sprites.scale.x
@onready var spriteScaleY = enemy_sprites.scale.y
var isGrounded = true
@onready var ray_cast_2d = $EnemySprites/RayCast2D


@export var group: String
var player
@export var playerScene: String
@export var playerGroup: String

func _ready():
	if group != "":
		self.add_to_group(group)
	
	player = get_node("/root/" + playerScene + "/Player")

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	Gravity()
	if canMove:
		Move()
	if canAttack:
		Attack()
	Death()
	#if is_on_floor() && motion.x == 0:
		#$AnimatedSprite2D.play("Idle")
	
	
	#look_at(get_parent().get_node("Player").posation.x)
	
	if isDie:
		ray_cast_2d.enabled = false

func Gravity():
	if !is_on_floor():
		motion.y += gravity

func Move():
	var direction = (player.global_position - global_position).normalized()
	
	if !isDie:
		# Make the enemy look at the player
		if direction.x < 0:
			dir = -1
			enemy_sprites.scale.x = spriteScaleX  # Flip sprite horizontally if player is to the left
		else:
			dir = 1
			enemy_sprites.scale.x = -spriteScaleX   # Flip sprite back if player is to the right

func Attack():
	if ray_cast_2d.get_collider() == player && !isDie:
		motion.x = runningSpeed * dir
	else:
		motion.x = 0

func Death():
	if lifePoints == 0 && !isDie:
		isDie = true
		$AnimationPlayer.play(deadAnimation)
		if is_on_floor():
			gravity = 0
			$CollisionShape2D.disabled = true
		else:
			gravity = 98
			$CollisionShape2D.disabled = false
	
	#if !isGrounded && is_on_floor() && motion.y > 400 && !isDie:
		#isDie = true
		#$AnimationPlayer.play(deadAnimation)
		#
		#isGrounded = is_on_floor()
