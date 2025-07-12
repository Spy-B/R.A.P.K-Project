extends CanvasLayer

@export var phone_ui: CanvasLayer

@onready var fps: Label = $Control/FPS
@onready var ammo_label: Label = $Control/AmmoLabel
@onready var combo_counter_label: Label = $Control/ComboCounter
@onready var interact_key: TextureRect = $Control/InteractKey
@onready var health_bar: TextureProgressBar = $Control/HealthBar
@onready var loading_icon: AnimatedSprite2D = $Control/LoadingIconControl/LoadingIcon
@onready var feed_effect: CanvasLayer = $FeedEffect

func _ready() -> void:
	#feed_effect.visible = true
	
	if !Global.android_ui_activated:
		if OS.get_name() == "Android":
			phone_ui.visible = true
			
			health_bar.size = Global.android_settings.health_bar_size
			health_bar.position = Global.android_settings.health_bar_position
			
			Global.android_ui_activated = true
		else:
			phone_ui.visible = false

func _process(_delta: float) -> void:
	fps.text = str(Engine.get_frames_per_second())
	ammo_label.text = str("Ammo: ", get_parent().ammoInMag, " / ", get_parent().extraAmmo)

func combo_counter() -> void:
	#var tween: Tween = get_tree().create_tween().set_parallel(true)
	
	#if get_parent().in_combo_fight:
		#combo_counter.visible = true
		#tween.tween_property(combo_counter, "global_position:x", 96.0, 0.2).from(-60.0).set_ease(Tween.EASE_IN_OUT)
		#tween.tween_property(combo_counter, "modulate", Color.html("ffffff"), 0.2).from(Color.html("ffffff00")).set_ease(Tween.EASE_IN_OUT)
	
	#elif !get_parent().in_combo_fight:
		#tween.tween_property(combo_counter, "global_position:x", -60.0, 0.2).from(96.0).set_ease(Tween.EASE_OUT_IN)
		#tween.tween_property(combo_counter, "modulate", Color.html("ffffff00"), 2.0).from(Color.html("ffffff")).set_ease(Tween.EASE_IN_OUT)
	pass

func saving_loading() -> void:
	loading_icon.play("Loading")
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(loading_icon, "modulate", Color.html("ffffff"), 0.2).from(Color.html("ffffff00"))
	tween.tween_interval(0.2)
	tween.tween_property(loading_icon, "modulate", Color.html("ffffff00"), 0.2).from(Color.html("ffffff"))
	
	await get_tree().create_timer(1.0).timeout
	loading_icon.stop()
