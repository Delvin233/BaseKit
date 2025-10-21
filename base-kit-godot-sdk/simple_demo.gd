extends Control

@onready var basekit_button = $VBoxContainer/BaseKitButton
@onready var welcome_label = $VBoxContainer/WelcomeLabel
@onready var game_area = $VBoxContainer/GameArea

func _ready():
	# Connect to BaseKit button signals
	basekit_button.wallet_connected.connect(_on_wallet_connected)
	basekit_button.wallet_disconnected.connect(_on_wallet_disconnected)
	
	# Initial state
	_update_game_state()

func _on_wallet_connected(address: String, base_name: String):
	print("🎮 Player connected: ", base_name)
	welcome_label.text = "Welcome, " + base_name + "!"
	_update_game_state()

func _on_wallet_disconnected():
	print("🎮 Player disconnected")
	welcome_label.text = "Connect your wallet to play!"
	_update_game_state()

func _update_game_state():
	var is_connected = BaseKit.is_wallet_connected()
	
	# Show/hide game content based on connection
	game_area.visible = is_connected
	
	if is_connected:
		welcome_label.modulate = Color.GREEN
	else:
		welcome_label.modulate = Color.WHITE
