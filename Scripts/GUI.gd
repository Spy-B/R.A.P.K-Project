extends CanvasLayer

# warning-ignore:unused_argument
@warning_ignore("unused_parameter")
func _physics_process(delta):
	$AmmunitionCounter.text = "Ammunition: " + str(get_parent().get_node("Player").ammoInMag) + "/" + str(get_parent().get_node("Player").extraAmmo)
	$FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	$ComboCounter.text = str(get_parent().get_node("Player").killCombo)
