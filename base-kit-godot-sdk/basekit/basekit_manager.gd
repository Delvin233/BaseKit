extends Node

# BaseKit Main Manager (Singleton)
# This will be added as AutoLoad

signal wallet_connected(address: String)
signal wallet_disconnected()
signal basename_resolved(address: String, name: String)
signal avatar_loaded(texture: Texture2D)
signal connection_error(message: String)

var current_address: String = ""
var current_basename: String = ""
var current_avatar: Texture2D
var is_connected: bool = false

# Components
var wallet_connector: WalletConnector
var basename_resolver: BaseNameResolver
var session_manager

func _ready():
	print("[BaseKit] Manager initialized")
	_setup_components()

func _setup_components():
	# Create wallet connector
	wallet_connector = WalletConnector.new()
	add_child(wallet_connector)
	
	# Create basename resolver
	basename_resolver = BaseNameResolver.new()
	add_child(basename_resolver)
	
	# Connect signals
	wallet_connector.connection_success.connect(_on_wallet_connection_success)
	wallet_connector.connection_failed.connect(_on_wallet_connection_failed)
	basename_resolver.name_resolved.connect(_on_name_resolved)
	basename_resolver.avatar_resolved.connect(_on_avatar_resolved)

# Main API Functions
func connect_wallet() -> void:
	print("[BaseKit] Connecting wallet...")
	if wallet_connector:
		wallet_connector.connect_wallet()
	else:
		connection_error.emit("Wallet connector not initialized")

func disconnect_wallet() -> void:
	print("[BaseKit] Disconnecting wallet...")
	current_address = ""
	current_basename = ""
	current_avatar = null
	is_connected = false
	wallet_disconnected.emit()

func get_connected_address() -> String:
	return current_address

func get_base_name() -> String:
	return current_basename if current_basename != "" else _format_address(current_address)

func get_avatar() -> Texture2D:
	return current_avatar

func is_wallet_connected() -> bool:
	return is_connected

# Helper Functions
func _format_address(address: String) -> String:
	if address.length() < 10:
		return address
	return address.substr(0, 6) + "..." + address.substr(-4)

# Wallet connector callbacks
func _on_wallet_connection_success(address: String):
	current_address = address
	is_connected = true
	
	print("[BaseKit] Wallet connected successfully: ", address)
	wallet_connected.emit(address)
	
	# Resolve Base Name using the resolver
	if basename_resolver:
		basename_resolver.resolve_base_name(address)

func _on_name_resolved(address: String, name: String):
	if address == current_address:
		current_basename = name
		print("[BaseKit] Base Name resolved: ", name)
		basename_resolved.emit(address, name)
		
		# Also try to get avatar
		if basename_resolver and name.ends_with(".base.eth"):
			basename_resolver.resolve_avatar(name)

func _on_avatar_resolved(name: String, avatar_url: String):
	if name == current_basename:
		print("[BaseKit] Avatar resolved: ", avatar_url)
		# For now, just log the URL - we'd need to download the image
		# avatar_loaded.emit(texture) - would emit actual texture

func _on_wallet_connection_failed(error: String):
	print("[BaseKit] Wallet connection failed: ", error)
	connection_error.emit(error)