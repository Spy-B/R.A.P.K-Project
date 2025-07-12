extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var damagingState: State
@export var deathState: State

@export_range(0, 1, 0.02) var reloadingTime: float = 1.0

@onready var reloading_time: Timer = $"../../Timers/ReloadingTime"
var reaload_done: bool = true

func enter() -> void:
	reaload_done = false
	
	reloading_time.wait_time = reloadingTime
	reloading_time.start()

func process_frame(_delta: float) -> State:
	if parent.damaged:
		parent.damaged = false
		return damagingState
	
	if parent.health <= 0:
		return deathState
	
	if reaload_done:
		return idleState
	
	return null

func _on_reloading_timer_timeout() -> void:
	var ammo_needed: int = (parent.maxAmmo - parent.ammoInMag)
	
	if parent.ammoInMag == 0 && parent.extraAmmo >= ammo_needed || parent.ammoInMag < parent.maxAmmo && parent.extraAmmo != 0 && parent.extraAmmo >= ammo_needed:
		parent.extraAmmo -= ammo_needed
		parent.ammoInMag += ammo_needed
		
	elif parent.ammoInMag == 0 && parent.extraAmmo < ammo_needed || parent.extraAmmo < ammo_needed:
		parent.ammoInMag += parent.extraAmmo
		parent.extraAmmo = 0
	
	reaload_done = true
	reloading_time.stop()
