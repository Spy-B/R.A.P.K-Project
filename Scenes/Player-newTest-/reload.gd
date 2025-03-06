extends State

@export var idleState: State
@export var walkingState: State
@export var runningState: State
@export var startJumpingState: State
@export var fallingState: State
@export var attackingState: State
@export var shootingState: State
@export var deathState: State

@export_range(0, 1, 0.02) var reloadingTime: float = 1.0

@onready var reloading_timer: Timer = $"../../Timers/ReloadingTimer"
var can_fire := true

func enter() -> void:
	can_fire = false
	
	reloading_timer.wait_time = reloadingTime
	reloading_timer.start()

func process_frame(_delta: float) -> State:
	if parent.health <= 0:
		return deathState
	
	if can_fire:
		return idleState
	
	return null


func _on_reloading_timer_timeout() -> void:
	var ammo_needed = (parent.maxAmmo - parent.ammoInMag)
	
	if parent.ammoInMag == 0 && parent.extraAmmo >= ammo_needed || parent.ammoInMag < parent.maxAmmo && parent.extraAmmo != 0 && parent.extraAmmo >= ammo_needed:
		parent.extraAmmo -= ammo_needed
		parent.ammoInMag += ammo_needed
		
	elif parent.ammoInMag == 0 && parent.extraAmmo < ammo_needed || parent.extraAmmo < ammo_needed:
		parent.ammoInMag += parent.extraAmmo
		parent.extraAmmo = 0
	
	can_fire = true
	reloading_timer.stop()
