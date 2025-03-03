extends CharacterBody2D

@export_group("Animation list")
@export var trapAnimation: String;

@export_group("Trap mode")
@export var trapSpeed: float = 150

@export_group("Target")
@export var playerGroup: String;
@export var damage: float;

@export_group("Camera Shake")
@export var amountX: float = 0
@export var amountY: float = 0
@export var shakeTime: float = 1

var tween: Tween
var dir: float = -1;

@onready var animationPlayer: AnimationPlayer = get_node("Area2D/AnimationPlayer");
@onready var trapRayRight: RayCast2D = get_node("TrapRayCast/trapRayRight");
@onready var trapRayLeft: RayCast2D = get_node("TrapRayCast/trapRayLeft");

func _ready() -> void:
	velocity.x = trapSpeed
	animationPlayer.play(trapAnimation)

func _physics_process(_delta: float) -> void:
	_trap_movement(trapRayRight, trapRayLeft, playerGroup, trapSpeed, dir);

func  _trap_movement(ray_cast_right : RayCast2D, ray_cast_left: RayCast2D, target_name : String, trap_speed: float, direction: float) -> void:
	if ray_cast_left.is_colliding() || ray_cast_right.is_colliding():
		var trl = ray_cast_left.get_collider();
		var trr = ray_cast_right.get_collider();
		if trl && !trl.is_in_group(target_name) || trr && !trr.is_in_group(target_name):
			if ray_cast_left.is_colliding() && ! ray_cast_right.is_colliding():
				velocity.x = trap_speed
			elif !ray_cast_left.is_colliding() &&  ray_cast_right.is_colliding():
				velocity.x = trap_speed * direction;
	move_and_slide();

func _player_enterd_the_trap(body: Node2D) -> void:
	if body.is_in_group(playerGroup):
		Global.playerHealthValue -= damage;
		Global.camera.shake(shakeTime, amountX, amountY)
