extends Node

var timeScale: float = 1.0
var in_game: bool = false
var is_chased : bool = false

var ammo_in_mag: int = 0
var extra_ammo: int = 0
var max_ammo: int = 0

var enemy_ammo_in_mag: int = 0
var enemy_extra_ammo: int = 0
var enemy_max_ammo: int = 0

var meleeComboCounter: int = 0
var killComboCounter: int = 0

var enemyLifePoints: int = 2

var inConversation: bool = false

var android_ui_activated: bool = false

#var player_node: Node = null

var loading_scene: PackedScene = preload("uid://b5b5dfh0nfqbt")
var next_scene: String = "uid://cvplrh5krh46n"

var android_settings: Dictionary = {
	"health_bar_size": Vector2(672.0, 224.0),
	"health_bar_position": Vector2(48.0, -48.0)
}

var selected_slat: int
var started_new_game: bool = false
var played_time: String

var current_slat: Dictionary = {
	"lvl": "",
	"enemies_killed": [],
	"xp": 0,
	"ammo": 0,
	"checkpoint": Vector2.ZERO,
	"checkpoints_taken": [],
}

var saving_slats: Dictionary = {
	"slat1": {
		"lvl": "",
		"enemies_killed": [],
		"xp": 0,
		"ammo": 0,
		"checkpoint": Vector2.ZERO,
		"checkpoints_taken": [],
	},
	"slat2": {
		"lvl": "",
		"enemies_killed": [],
		"xp": 0,
		"ammo": 0,
		"checkpoint": Vector2.ZERO,
		"checkpoints_taken": [],
	},
	"slat3": {
		"lvl": "",
		"enemies_killed": [],
		"xp": 0,
		"ammo": 0,
		"checkpoint": Vector2.ZERO,
		"checkpoints_taken": [],
	}
}

var save_game_path: String = "user://save_slat.rf"
var save_game_pass: String = "s9k@02KDsa>#d9"

func _ready() -> void:
	if Engine.has_singleton("ToastPlugin"):
		var toast_plugin := Engine.get_singleton("ToastPlugin")
		toast_plugin.connect("toast_shown", Callable(self, "_on_toast_shown"))
		toast_plugin.connect("toast_hidden", Callable(self, "_on_toast_hidden"))
		toast_plugin.connect("toast_callback", Callable(self, "_on_toast_callback"))
	else:
		print("[TOAST_PLUGIN] ToastPlugin not found")
	
	pass


func save_game(_kay: Variant = null, _value: Variant = null) -> void:
	match selected_slat:
		1:
			saving_slats.slat1 = current_slat
		2:
			saving_slats.slat2 = current_slat
		3:
			saving_slats.slat3 = current_slat
	
	if _kay != null && _value != null:
		current_slat[_kay] = _value
	
	var save_file: FileAccess = FileAccess.open_encrypted_with_pass(save_game_path, FileAccess.WRITE, save_game_pass)
	
	save_file.store_var(saving_slats)
	save_file.close()

func load_game() -> void:
	if !FileAccess.file_exists(save_game_path):
		started_new_game = true
		save_game()
	
	var load_file: FileAccess = FileAccess.open_encrypted_with_pass(save_game_path, FileAccess.READ, save_game_pass)
	saving_slats = load_file.get_var()
	
	match selected_slat:
		1:
			current_slat = saving_slats.slat1
		2:
			current_slat = saving_slats.slat2
		3:
			current_slat = saving_slats.slat3
	
	started_new_game = false
	
	load_file.close()

func default_values() -> Dictionary:
	var slat: Dictionary = {
		"lvl": "",
		"enemies_killed": [],
		"xp": 0,
		"ammo": 0,
		"checkpoint": Vector2.ZERO,
		"checkpoints_taken": [],
		"played_time": "",
		"last_one": true,
	}
	
	return slat
