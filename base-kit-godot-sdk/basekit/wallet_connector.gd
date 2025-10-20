class_name WalletConnector
extends Node

signal connection_success(address: String)
signal connection_failed(error: String)

var http_request: HTTPRequest
var current_rpc_url: String = BaseKitConfig.BASE_RPC_URL
var rpc_index: int = 0
var retry_count: int = 0
var max_retries: int = 3

func _ready():
	# Create HTTP request node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Test Base RPC connection
func test_connection() -> void:
	print("[WalletConnector] Testing Base RPC connection...")
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"jsonrpc": "2.0",
		"method": "eth_chainId",
		"params": [],
		"id": 1
	})
	
	var error = http_request.request(current_rpc_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		var error_msg = BaseKitErrorHandler.handle_error(
			BaseKitErrorHandler.ErrorType.NETWORK_ERROR,
			"Failed to make HTTP request",
			str(error)
		)
		_try_fallback_rpc(error_msg)

# Get latest block (to verify connection)
func get_latest_block() -> void:
	print("[WalletConnector] Getting latest block...")
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"jsonrpc": "2.0",
		"method": "eth_blockNumber",
		"params": [],
		"id": 2
	})
	
	var error = http_request.request(current_rpc_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		var error_msg = BaseKitErrorHandler.handle_error(
			BaseKitErrorHandler.ErrorType.NETWORK_ERROR,
			"Failed to get latest block",
			str(error)
		)
		connection_failed.emit(error_msg)

# Mock wallet connection (for now)
func connect_wallet() -> void:
	print("[WalletConnector] Attempting wallet connection...")
	
	# First test the RPC connection
	test_connection()
	
	# For now, simulate wallet connection after RPC test
	await get_tree().create_timer(2.0).timeout
	
	# Use a test address
	var test_address = "0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3"
	print("[WalletConnector] Mock wallet connected: ", test_address)
	connection_success.emit(test_address)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("[WalletConnector] HTTP Response - Code: ", response_code, " Result: ", result)
	
	if response_code != 200:
		var error_msg = BaseKitErrorHandler.handle_error(
			BaseKitErrorHandler.ErrorType.NETWORK_ERROR,
			"HTTP Error",
			str(response_code)
		)
		_try_fallback_rpc(error_msg)
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		var error_msg = BaseKitErrorHandler.handle_error(
			BaseKitErrorHandler.ErrorType.PARSING_ERROR,
			"Failed to parse JSON response"
		)
		connection_failed.emit(error_msg)
		return
	
	var response = json.data
	print("[WalletConnector] RPC Response: ", response)
	
	# Handle different RPC responses
	if response.has("result"):
		if response.has("id"):
			match response.id:
				1: # Chain ID response
					var chain_id = response.result
					if chain_id == "0x2105":  # Base mainnet chain ID in hex
						print("[WalletConnector] ✅ Connected to Base mainnet!")
					else:
						print("[WalletConnector] ⚠️ Connected to chain: ", chain_id)
				2: # Block number response
					print("[WalletConnector] ✅ Latest block: ", response.result)
	else:
		var error_msg = BaseKitErrorHandler.handle_error(
			BaseKitErrorHandler.ErrorType.RPC_ERROR,
			"Invalid RPC response",
			str(response)
		)
		connection_failed.emit(error_msg)

# Try fallback RPC endpoints
func _try_fallback_rpc(original_error: String):
	if rpc_index < BaseKitConfig.BACKUP_RPC_URLS.size():
		current_rpc_url = BaseKitConfig.BACKUP_RPC_URLS[rpc_index]
		rpc_index += 1
		print("[WalletConnector] Trying fallback RPC: ", current_rpc_url)
		test_connection()
	else:
		connection_failed.emit("All RPC endpoints failed. Last error: " + original_error)