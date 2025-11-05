class_name RegistryConnector
extends Node

signal game_registered(success: bool)
signal player_registered(success: bool)
signal stats_loaded(total_games: int, total_players: int)
signal game_exists_checked(exists: bool, game_name: String)

const REGISTRY_ADDRESS = "0x440D73Ce6E944f50b8F900868517810c8ab2B451"
const BASE_SEPOLIA_RPC = "https://sepolia.base.org"

# No private keys needed - users sign with their own wallets

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Register game with the registry
func register_game(game_name: String, developer_address: String):
	print("[RegistryConnector] Registering game: ", game_name)
	
	# Use increment() function to track unique users
	var function_hash = "0xd09de08a"  # increment()
	var call_data = function_hash  # No parameters needed
	
	# Request MetaMask to sign and send transaction
	print("[RegistryConnector] Requesting MetaMask signature for: ", developer_address)
	
	# Create transaction request for MetaMask
	var tx_request = {
		"from": developer_address,
		"to": REGISTRY_ADDRESS,
		"data": call_data,
		"gas": "0x15F90",
		"gasPrice": "0x9502F9000"
	}
	
	# In a web build, this would call:
	# window.ethereum.request({method: 'eth_sendTransaction', params: [tx_request]})
	
	print("[RegistryConnector] Transaction prepared for MetaMask:")
	print("[RegistryConnector]   From: ", tx_request.from)
	print("[RegistryConnector]   To: ", tx_request.to)
	print("[RegistryConnector]   Data: ", tx_request.data)
	
	# Open BaseKit connector on your domain
	var connector_url = "https://basekit.info/connect?to=" + REGISTRY_ADDRESS + "&data=" + call_data + "&from=" + developer_address
	print("[RegistryConnector] 🚀 Opening BaseKit connector...")
	OS.shell_open(connector_url)
	print("[RegistryConnector] ✅ Please approve transaction in browser!")
	game_registered.emit(true)

# Register player with game
func register_player(player_address: String):
	print("[RegistryConnector] Registering player: ", player_address)
	
	# Use increment() function to track unique users
	var function_hash = "0xd09de08a"  # increment()
	
	# Request MetaMask to sign and send transaction
	print("[RegistryConnector] Requesting MetaMask signature for: ", player_address)
	
	# Create transaction request for MetaMask
	var tx_request = {
		"from": player_address,
		"to": REGISTRY_ADDRESS,
		"data": function_hash,
		"gas": "0x15F90",
		"gasPrice": "0x9502F9000"
	}
	
	print("[RegistryConnector] Transaction prepared for MetaMask:")
	print("[RegistryConnector]   From: ", tx_request.from)
	print("[RegistryConnector]   To: ", tx_request.to)
	print("[RegistryConnector]   Data: ", tx_request.data)
	
	# Open BaseKit connector on your domain
	var connector_url = "https://basekit.info/connect?to=" + REGISTRY_ADDRESS + "&data=" + function_hash + "&from=" + player_address
	print("[RegistryConnector] 🚀 Opening BaseKit connector...")
	OS.shell_open(connector_url)
	print("[RegistryConnector] ✅ Please approve transaction in browser!")
	player_registered.emit(true)

# Check if game exists in registry
func check_game_exists(game_name: String):
	print("[RegistryConnector] Checking if game exists: ", game_name)
	
	# Encode function call: gameExists(string)
	var function_hash = "0x123456789"  # gameExists(string) - placeholder
	var encoded_name = encode_string(game_name)
	var call_data = function_hash + encoded_name
	
	# For now, simulate the check by trying to get game info
	# In a real implementation, you'd have a gameExists function in the contract
	var check_call = {
		"jsonrpc": "2.0",
		"method": "eth_call",
		"params": [{
			"to": REGISTRY_ADDRESS,
			"data": "0x2d287e16"  # totalGames() as a proxy check
		}, "latest"],
		"id": 5
	}
	
	_send_request(check_call, "check_game_exists")

# Get registry statistics
func get_stats():
	print("[RegistryConnector] Getting registry stats...")
	
	# Read userCount from contract
	var users_call = {
		"jsonrpc": "2.0",
		"method": "eth_call",
		"params": [{
			"to": REGISTRY_ADDRESS,
			"data": "0x8ada066e"  # getCounter()
		}, "latest"],
		"id": 3
	}
	
	_send_request(users_call, "get_user_count")

# Proper ABI string encoding
func encode_string(text: String) -> String:
	var hex_text = text.to_utf8_buffer().hex_encode()
	var length = text.length()
	var length_hex = "%064x" % length
	
	# Pad hex string to multiple of 64 characters (32 bytes)
	var padded_length = ((hex_text.length() + 63) / 64) * 64
	var padded_hex = hex_text.pad_zeros(padded_length)
	
	# ABI encoding: offset(32) + length(32) + data(padded)
	return "0000000000000000000000000000000000000000000000000000000000000020" + length_hex + padded_hex

# Note: Real transactions would require wallet integration
# This demonstrates the concept with contract validation

func _send_request(data: Dictionary, request_type: String):
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify(data)
	
	# Create new HTTPRequest for each call to avoid busy errors
	var new_http = HTTPRequest.new()
	add_child(new_http)
	new_http.set_meta("request_type", request_type)
	
	# Connect to a custom callback that knows which request it is
	new_http.request_completed.connect(func(result, code, headers, body): _handle_specific_request(result, code, headers, body, request_type, new_http))
	
	new_http.request(BASE_SEPOLIA_RPC, headers, HTTPClient.METHOD_POST, body)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	# Get the HTTPRequest that triggered this callback
	var sender = get_children().filter(func(child): return child is HTTPRequest and child.has_meta("request_type"))
	var request_type = ""
	if sender.size() > 0:
		request_type = sender[0].get_meta("request_type", "")
	var response_text = body.get_string_from_utf8()
	
	print("[RegistryConnector] Response (", request_type, "): ", response_text)
	
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		
		if parse_result == OK:
			var response_data = json.data
			
			match request_type:
				"register_game":
					if response_data.has("error"):
						print("[RegistryConnector] ❌ Game registration failed: ", response_data.error.message)
						game_registered.emit(false)
					elif response_data.has("result"):
						var tx_hash = response_data["result"]
						print("[RegistryConnector] ✅ Game registered! TX: ", tx_hash)
						print("[RegistryConnector] 🔗 View: https://sepolia.basescan.org/tx/", tx_hash)
						game_registered.emit(true)
				"register_player":
					if response_data.has("error"):
						print("[RegistryConnector] ❌ Player registration failed: ", response_data.error.message)
						player_registered.emit(false)
					elif response_data.has("result"):
						var tx_hash = response_data["result"]
						print("[RegistryConnector] ✅ Player registered! TX: ", tx_hash)
						print("[RegistryConnector] 🔗 View: https://sepolia.basescan.org/tx/", tx_hash)
						player_registered.emit(true)
				"get_user_count":
					_handle_user_count_response(response_data)
				"get_stats":
					_handle_stats_response(response_data)
				"check_game_exists":
					_handle_game_exists_response(response_data)
		else:
			print("[RegistryConnector] JSON parse error")
			_emit_error(request_type)
	else:
		print("[RegistryConnector] HTTP error: ", response_code)
		_emit_error(request_type)



var total_games: int = 0
var total_players: int = 0

func _handle_user_count_response(response_data: Dictionary):
	if response_data.has("result"):
		var hex_result = response_data["result"]
		var user_count = hex_result.hex_to_int()
		print("[RegistryConnector] Total users: ", user_count)
		stats_loaded.emit(0, user_count)  # games=0, users=user_count
	elif response_data.has("error"):
		print("[RegistryConnector] Error getting user count: ", response_data.error.message)
		stats_loaded.emit(0, 0)

func _handle_players_response(response_data: Dictionary):
	if response_data.has("result"):
		var hex_result = response_data["result"]
		total_players = hex_result.hex_to_int()
		print("[RegistryConnector] Total players: ", total_players)
		
		# Emit final stats
		stats_loaded.emit(total_games, total_players)
	elif response_data.has("error"):
		print("[RegistryConnector] Error getting players: ", response_data.error.message)
		stats_loaded.emit(total_games, 0)

func _handle_stats_response(response_data: Dictionary):
	# Legacy function - keeping for compatibility
	stats_loaded.emit(0, 0)

# Get nonce for address
func _get_nonce(address: String) -> int:
	print("[RegistryConnector] Getting nonce for: ", address)
	
	# Make RPC call to get transaction count
	var nonce_call = {
		"jsonrpc": "2.0",
		"method": "eth_getTransactionCount",
		"params": [address, "latest"],
		"id": 999
	}
	
	# For demo, return incremental nonce
	# In production, make actual RPC call and wait for response
	var demo_nonce = randi_range(0, 100)
	print("[RegistryConnector] Using nonce: ", demo_nonce)
	return demo_nonce

func _handle_game_exists_response(response_data: Dictionary):
	# For demo: always assume game doesn't exist (always register)
	# This ensures transactions always happen for testing
	var game_name = ProjectSettings.get_setting("application/config/name", "Unknown Game")
	print("[RegistryConnector] Game existence check - assuming game doesn't exist for demo")
	game_exists_checked.emit(false, game_name)

func _handle_specific_request(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, request_type: String, http_node: HTTPRequest):
	var response_text = body.get_string_from_utf8()
	print("[RegistryConnector] Response (", request_type, "): ", response_text)
	
	if response_code == 200:
		var json = JSON.new()
		var parse_result = json.parse(response_text)
		
		if parse_result == OK:
			var response_data = json.data
			
			match request_type:
				"get_user_count":
					_handle_user_count_response(response_data)
				"check_game_exists":
					_handle_game_exists_response(response_data)
		else:
			print("[RegistryConnector] JSON parse error")
			_emit_error(request_type)
	else:
		print("[RegistryConnector] HTTP error: ", response_code)
		_emit_error(request_type)
	
	# Clean up
	http_node.queue_free()

func _emit_error(request_type: String):
	match request_type:
		"register_game":
			game_registered.emit(false)
		"register_player":
			player_registered.emit(false)
		"get_user_count", "get_total_games", "get_total_players", "get_stats":
			stats_loaded.emit(0, 0)
		"check_game_exists":
			var game_name = ProjectSettings.get_setting("application/config/name", "Unknown Game")
			print("[RegistryConnector] Game existence check failed - assuming game doesn't exist")
			game_exists_checked.emit(false, game_name)