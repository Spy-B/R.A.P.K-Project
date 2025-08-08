extends Node

#var global_script := "res://Scripts/Global.gd"
#var editor_plugin := EditorPlugin.new()

#var dictionary: Dictionary = {
	#"move_right_event": InputEvent.new()
#}

var event := InputEventKey.new()

func _ready() -> void:
	#editor_plugin.add_autoload_singleton("testGlobal", "res://Scripts/Global.gd")
	InputMap.add_action("move_right_test")
	
	event.physical_keycode = KEY_B
	InputMap.action_add_event("move_right_test", event)
	
	#InputMap.add_action("move_left")
	#
	#InputMap.add_action("move_up")
	#
	#InputMap.add_action("move_down")
	#
	#InputMap.add_action("run")
	#
	#InputMap.add_action("jump")
	#
	#InputMap.add_action("reload")
	#
	#InputMap.add_action("attack")
	#
	#InputMap.add_action("shoot")
	#
	#InputMap.add_action("interact")
	#
	#InputMap.add_action("pause")
	#
	#InputMap.add_action("restart")
	#
	#InputMap.add_action("continue")
	#
	#InputMap.add_action("super")
	#
	#InputMap.add_action("dash")
