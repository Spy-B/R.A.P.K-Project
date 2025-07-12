extends State

@export var idleState: State
@export var respawningState: State

@onready var respawn_timer: Timer = $"../../Timers/RespawnTimer"

var respawn_timeout: bool = false

func enter() -> void:
	super()
	
	respawn_timer.start()
	
	Engine.time_scale = 0.5

func process_frame(_delta: float) -> State:
	if respawn_timeout:
		respawn_timeout = false
		Engine.time_scale = 1.0
		return respawningState
	
	return null


func _on_respawn_timer_timeout() -> void:
	respawn_timeout = true
