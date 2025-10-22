@tool
extends EditorPlugin

func _enter_tree():
	print("BaseKit plugin activated! 🦕")
	# Add BaseKit as autoload if not already added
	if not ProjectSettings.has_setting("autoload/BaseKit"):
		add_autoload_singleton("BaseKit", "res://basekit/basekit_manager.gd")

func _exit_tree():
	print("BaseKit plugin deactivated")
	# Remove autoload when plugin is disabled
	remove_autoload_singleton("BaseKit")

func get_plugin_name():
	return "BaseKit"