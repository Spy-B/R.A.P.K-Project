extends Path2D

@export var loop := true
@export var speed := 2.0
@export var speedScale := 1.0

@onready var pathFollower = $PathFollow2D
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	if !loop:
		animation_player.play("Moving")
		animation_player.speed_scale = speedScale
		set_process(false)

func _physics_process(_delta: float) -> void:
	pathFollower.progress += speed
