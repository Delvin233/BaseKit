extends Control

@onready var connect_button = $VBoxContainer/ConnectButton
@onready var status_label = $VBoxContainer/StatusLabel
@onready var address_label = $VBoxContainer/AddressLabel
@onready var basename_label = $VBoxContainer/BaseNameLabel

func _ready():
	# Connect to BaseKit signals
	BaseKit.wallet_connected.connect(_on_wallet_connected)
	BaseKit.wallet_disconnected.connect(_on_wallet_disconnected)
	BaseKit.basename_resolved.connect(_on_basename_resolved)
	BaseKit.connection_error.connect(_on_connection_error)
	
	# Connect button signal
	connect_button.pressed.connect(_on_connect_button_pressed)
	
	# Initial state
	_update_ui_state()

func _on_connect_button_pressed():
	if BaseKit.is_wallet_connected():
		BaseKit.disconnect_wallet()
	else:
		status_label.text = "Connecting..."
		connect_button.disabled = true
		BaseKit.connect_wallet()

func _on_wallet_connected(address: String):
	print("[LoginPanel] Wallet connected: ", address)
	_update_ui_state()

func _on_wallet_disconnected():
	print("[LoginPanel] Wallet disconnected")
	_update_ui_state()

func _on_basename_resolved(address: String, name: String):
	print("[LoginPanel] Base Name resolved: ", name)
	_update_ui_state()

func _on_connection_error(message: String):
	status_label.text = "Error: " + message
	connect_button.disabled = false

func _update_ui_state():
	if BaseKit.is_wallet_connected():
		connect_button.text = "Disconnect"
		connect_button.disabled = false
		status_label.text = "Connected!"
		address_label.text = "Address: " + BaseKit.get_connected_address()
		basename_label.text = "Base Name: " + BaseKit.get_base_name()
		
		# Show connected info
		address_label.visible = true
		basename_label.visible = true
	else:
		connect_button.text = "Connect with Base"
		connect_button.disabled = false
		status_label.text = "Not connected"
		
		# Hide connected info
		address_label.visible = false
		basename_label.visible = false