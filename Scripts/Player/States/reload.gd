extends State

@onready var reloading_timer: Timer = $"../../Timers/ReloadingTimer"
var reaload_done: bool = true


func enter() -> void:
	print("[State] -> Reloading")
	super()
	
	reaload_done = false
	parent.runtime_vars.can_fire = false
	
	reloading_timer.wait_time = parent.reloadingTime
	reloading_timer.start()

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
	if reaload_done:
		return parent.idleState
	
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
	parent.runtime_vars.can_fire = true
	reloading_timer.stop()
