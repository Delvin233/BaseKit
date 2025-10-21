extends Control

@onready var basekit_button = $VBoxContainer/BaseKitButton
@onready var welcome_label = $VBoxContainer/WelcomeLabel
@onready var avatar_display = $VBoxContainer/AvatarDisplay
@onready var game_area = $VBoxContainer/GameArea

func _ready():
	# Connect to BaseKit button signals
	basekit_button.wallet_connected.connect(_on_wallet_connected)
	basekit_button.wallet_disconnected.connect(_on_wallet_disconnected)
	
	# Connect to BaseKit signals
	BaseKit.avatar_loaded.connect(_on_avatar_loaded)
	BaseKit.basename_resolved.connect(_on_basename_resolved)
	
	# Initial state
	_update_game_state()

func _on_wallet_connected(address: String, base_name: String):
	print("🎮 Player connected: ", address)
	# Use BaseKit's method to get the most current name
	var current_name = BaseKit.get_base_name()
	welcome_label.text = "Welcome, " + current_name + "!"
	_update_game_state()

func _on_wallet_disconnected():
	print("🎮 Player disconnected")
	welcome_label.text = "Connect your wallet to play!"
	avatar_display.texture = null
	_update_game_state()

func _on_avatar_loaded(texture: Texture2D):
	print("🎮 Avatar loaded!")
	avatar_display.texture = texture

func _on_basename_resolved(address: String, name: String):
	print("🎮 Base Name resolved: ", name)
	# Update welcome message with the resolved name
	welcome_label.text = "Welcome, " + name + "!"

func _update_game_state():
	var is_connected = BaseKit.is_wallet_connected()
	
	# Show/hide game content based on connection
	game_area.visible = is_connected
	
	if is_connected:
		welcome_label.modulate = Color.GREEN
	else:
		welcome_label.modulate = Color.WHITE
