extends State

@onready var respawn_timer: Timer = $"../../Timers/RespawnTimer"

var respawn_timeout: bool = false

func enter() -> void:
	print("[State] -> Death")
	super()
	
	respawn_timer.start()
	
	Engine.time_scale = 0.5

func process_frame(_delta: float) -> State:
	if respawn_timeout:
		respawn_timeout = false
		Engine.time_scale = 1.0
		return parent.respawningState
	
	return null


func _on_respawn_timer_timeout() -> void:
	respawn_timeout = true
