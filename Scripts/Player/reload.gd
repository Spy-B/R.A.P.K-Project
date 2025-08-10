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


@onready var reloading_timer: Timer = $"../../Timers/ReloadingTimer"
var reaload_done: bool = true


func enter() -> void:
	reaload_done = false
	
	reloading_timer.wait_time = parent.reloadingTime
	reloading_timer.start()

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
	reloading_timer.stop()
