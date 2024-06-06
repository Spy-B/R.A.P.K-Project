extends CharacterBody2D

var motion = Vector2(0, 0)
@export var gravity = 98
@export var speed = 100

@export var canMove = true
var isMovingLeft = true

@export var lifePoints: float = Global.enemiesLifePoints
@export var deadAnimation: String

@export var group: String

var player

func _ready():
	if group != "":
		self.add_to_group(group)
	
	player = get_node("/root/World/Player")

@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_velocity(motion)
	set_up_direction(Vector2.UP)
	move_and_slide()
	motion = velocity
	
	Gravity()
	Move()
	Death()
	#if is_on_floor() && motion.x == 0:
		#$AnimatedSprite2D.play("Idle")
	
	
	#look_at(get_parent().get_node("Player").posation.x)

func Gravity():
	if !is_on_floor():
		motion.y += gravity

func Move():
	var direction = (player.global_position - global_position).normalized()
	
	# Make the enemy look at the player
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true  # Flip sprite horizontally if player is to the left
	else:
		$AnimatedSprite2D.flip_h = false   # Flip sprite back if player is to the right

func Death():
	if lifePoints == 0:
		lifePoints = 3
		$AnimationPlayer.play(deadAnimation)
		if is_on_floor():
			gravity = 0
			$CollisionShape2D.disabled = true
