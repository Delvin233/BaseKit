extends Control

@onready var basekit_button = $BaseKitButton
@onready var start_button = $Start_button
@onready var game_title = $game_title

func _ready() -> void:
	# Connect BaseKit signals
	BaseKit.wallet_connected.connect(_on_wallet_connected)
	BaseKit.wallet_disconnected.connect(_on_wallet_disconnected)
	BaseKit.basename_resolved.connect(_on_basename_resolved)
	
	# Connect start button
	start_button.pressed.connect(_on_start_game)
	
	# Initially hide start button until wallet is connected
	start_button.visible = false
	
	# Check if already connected (with delay to allow session loading)
	await get_tree().process_frame
	if BaseKit.is_wallet_connected():
		print("[MainMenu] Wallet already connected, showing connected state")
		_show_connected_state()
	else:
		print("[MainMenu] No wallet connected, showing disconnected state")
		_show_disconnected_state()

func _on_wallet_connected(address: String):
	_show_connected_state()

func _on_wallet_disconnected():
	_show_disconnected_state()

func _on_basename_resolved(address: String, basename: String):
	game_title.text = "Welcome to Coin Adventure !"
	# Get registry stats for demo
	BaseKit.get_registry_stats()

func _show_connected_state():
	print("[MainMenu] Showing connected state")
	basekit_button.visible = true
	start_button.visible = true
	
	# Update title with Base Name or address
	var display_name = BaseKit.get_base_name()
	if display_name.is_empty():
		display_name = BaseKit.get_connected_address()
	if display_name.is_empty():
		display_name = "Connected User"
	game_title.text = "Welcome, " + display_name + "!"

func _show_disconnected_state():
	print("[MainMenu] Showing disconnected state")
	basekit_button.visible = true
	start_button.visible = false
	game_title.text = "Coin Adventure"

func _on_start_game():
	get_tree().change_scene_to_file("res://examples/scenes/game.tscn")
