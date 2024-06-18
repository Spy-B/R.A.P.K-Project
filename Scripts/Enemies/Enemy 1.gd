extends CharacterBody2D

var motion = Vector2.ZERO

@export var gravity = 98

@export_group("Movement")
@export var canMove = true
@export var runningSpeed = 100
var isMovingLeft = true
@onready var animation_player = $AnimationPlayer
var dir = 1

@export_range(0, 10) var timeScale: float = 1

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
@export var lvlScene: String
@export var followLvlSceneTime = true

@export var playerGroup: String

func _ready():
	if group != "":
		self.add_to_group(group)
	
	player = get_node("/root/" + lvlScene + "/Player")

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if followLvlSceneTime:
		timeScale = Global.timeScale
	
	set_velocity(motion * timeScale)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	if canMove:
		Move()
	else:
		motion.x = 0
	
	Gravity()
	Death()

func Gravity():
	if !is_on_floor():
		motion.y += gravity

func Move():
	motion.x = -runningSpeed if isMovingLeft else runningSpeed
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x
	if $RayCast2D2.is_colliding() && is_on_floor():
		isMovingLeft = !isMovingLeft
		scale.x = -scale.x
	


func Death():
	if lifePoints == 0:
		queue_free()
	
