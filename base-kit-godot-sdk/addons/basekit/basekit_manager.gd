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
var wallet_connector: BrowserOAuthConnector
var basename_resolver: SmartBaseNameResolver
var session_manager: SessionManager
var avatar_loader: AvatarLoader
var contract_caller: BaseContractCaller
var registry_connector: RegistryConnector

func _ready():
	print("[BaseKit] Manager initialized")
	_setup_components()

func _setup_components():
	# Create browser OAuth wallet connector
	wallet_connector = BrowserOAuthConnector.new()
	add_child(wallet_connector)
	
	# Create smart basename resolver
	basename_resolver = SmartBaseNameResolver.new()
	add_child(basename_resolver)
	
	# Create avatar loader
	avatar_loader = AvatarLoader.new()
	add_child(avatar_loader)
	
	# Create session manager
	session_manager = SessionManager.new()
	add_child(session_manager)
	
	# Create contract caller
	contract_caller = BaseContractCaller.new()
	add_child(contract_caller)
	
	# Create registry connector
	registry_connector = RegistryConnector.new()
	add_child(registry_connector)
	
	# Connect signals
	wallet_connector.wallet_connected.connect(_on_wallet_connection_success)
	wallet_connector.connection_failed.connect(_on_wallet_connection_failed)
	basename_resolver.name_resolved.connect(_on_name_resolved)
	basename_resolver.avatar_resolved.connect(_on_avatar_resolved)
	avatar_loader.avatar_loaded.connect(_on_avatar_loaded)
	avatar_loader.avatar_failed.connect(_on_avatar_failed)
	session_manager.session_loaded.connect(_on_session_loaded)
	contract_caller.contract_call_completed.connect(_on_contract_call_completed)
	registry_connector.game_registered.connect(_on_game_registered)
	registry_connector.player_registered.connect(_on_player_registered)
	registry_connector.stats_loaded.connect(_on_stats_loaded)
	registry_connector.game_exists_checked.connect(_on_game_exists_checked)
	
	# Try to load existing session
	_try_auto_login()

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
	
	# Clear session
	if session_manager:
		session_manager.clear_session()
	
	wallet_disconnected.emit()

func get_connected_address() -> String:
	return current_address

func get_base_name() -> String:
	return current_basename if current_basename != "" else _format_address(current_address)

func get_avatar() -> Texture2D:
	return current_avatar

func is_wallet_connected() -> bool:
	return is_connected

# Registry Functions
func register_with_basekit(game_name: String) -> void:
	print("[BaseKit] Registering game with BaseKit: ", game_name)
	if is_connected and registry_connector:
		registry_connector.register_game(game_name, current_address)
	else:
		print("[BaseKit] Cannot register game - wallet not connected")

func get_registry_stats() -> void:
	print("[BaseKit] Getting registry statistics...")
	if registry_connector:
		registry_connector.get_stats()

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
	
	# Smart registration: check if game exists, if not register it first
	_smart_register_game_and_player()
	
	# Resolve Base Name using the resolver
	if basename_resolver:
		basename_resolver.resolve_base_name(address)

func _on_name_resolved(address: String, name: String):
	if address == current_address:
		current_basename = name
		print("[BaseKit] Base Name resolved: ", name)
		basename_resolved.emit(address, name)
		
		# Save session
		if session_manager:
			session_manager.save_session(address, name)
		
		# Also try to get avatar
		if basename_resolver and name.ends_with(".base.eth"):
			basename_resolver.resolve_avatar(name)

func _on_avatar_resolved(name: String, avatar_url: String):
	if name == current_basename:
		print("[BaseKit] Avatar resolved: ", avatar_url)
		# Load the actual avatar image
		if avatar_loader and avatar_url != "":
			avatar_loader.load_avatar(avatar_url)

func _on_avatar_loaded(texture: Texture2D):
	current_avatar = texture
	print("[BaseKit] ✅ Avatar loaded successfully!")
	avatar_loaded.emit(texture)

func _on_avatar_failed(error: String):
	print("[BaseKit] ❌ Avatar loading failed: ", error)

# Session management callbacks
func _on_session_loaded(address: String, basename: String):
	current_address = address
	current_basename = basename
	is_connected = true
	
	print("[BaseKit] 🔄 Session restored: ", basename)
	wallet_connected.emit(address)
	basename_resolved.emit(address, basename)
	
	# IMPORTANT: Also register user on session restore
	_register_user_immediately(address)
	
	# Try to load cached avatar
	var session_data = session_manager.get_current_session()
	if session_data.has("avatar_url") and session_data.avatar_url != "":
		avatar_loader.load_avatar(session_data.avatar_url)

func _on_contract_call_completed(result: String, context: Dictionary):
	print("[BaseKit] Contract call completed: ", context.get("method", "unknown"))
	# Handle different contract call results here

# Registry callbacks
# Registry callbacks
func _on_game_registered(success: bool):
	if success:
		print("[BaseKit] ✅ Game registered successfully! (First time setup)")
	else:
		print("[BaseKit] ❌ Game registration failed")
	# No longer auto-registering player here

# Callback for game existence check (not used in simple mode)
func _on_game_exists_checked(exists: bool, game_name: String):
	# Not used in current simple implementation
	pass

func _on_player_registered(success: bool):
	if success:
		print("[BaseKit] ✅ Player registered successfully!")
	else:
		print("[BaseKit] ❌ Player registration failed (might already be registered)")
	# Continue with game flow regardless of registration result

func _on_stats_loaded(total_games: int, total_players: int):
	print("[BaseKit] 📊 Registry Stats - Games: ", total_games, ", Players: ", total_players)

# Immediate user registration on wallet connect
func _smart_register_game_and_player():
	var game_name = ProjectSettings.get_setting("application/config/name", "Unknown Game")
	print("[BaseKit] Registering user immediately for: ", game_name)
	
	# Register user immediately (contract handles duplicates)
	if registry_connector:
		_register_user_immediately(current_address)

func _register_user_immediately(user_address: String):
	print("[BaseKit] 🚀 Registering user immediately: ", user_address)
	
	# Open browser immediately for user registration using simple increment
	var function_hash = "0xd09de08a"  # increment()
	var connector_url = "https://basekit.info/connect?to=" + registry_connector.REGISTRY_ADDRESS + "&data=" + function_hash + "&from=" + user_address
	
	print("[BaseKit] Opening registration immediately...")
	OS.shell_open(connector_url)
	print("[BaseKit] ✅ User registration opened - please sign!")

# Manual game registration (for game owner only)
func register_game_as_owner(game_name: String):
	print("[BaseKit] Owner registering game: ", game_name)
	if registry_connector and is_connected:
		registry_connector.register_game(game_name, current_address)
	else:
		print("[BaseKit] Cannot register game - wallet not connected")

# Auto-login functionality
func _try_auto_login():
	print("[BaseKit] Checking for existing session...")
	if session_manager.load_session():
		print("[BaseKit] ✅ Auto-login successful!")
	else:
		print("[BaseKit] No valid session found")

func _on_wallet_connection_failed(error: String):
	print("[BaseKit] Wallet connection failed: ", error)
	connection_error.emit(error)
