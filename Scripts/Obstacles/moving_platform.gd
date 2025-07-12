extends Path2D

@export var loop: bool = false
@export var speed: float = 1.0
@export var speedScale: float = 1.0

@onready var path_follower: PathFollow2D = $PathFollow2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if !loop:
		animation_player.play("Moving")
		animation_player.speed_scale = speedScale
		set_process(false)

func _process(_delta: float) -> void:
	path_follower.progress += speed
