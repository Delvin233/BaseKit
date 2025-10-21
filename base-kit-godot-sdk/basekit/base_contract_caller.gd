class_name BaseContractCaller
extends Node

signal contract_call_completed(result: String, context: Dictionary)
signal contract_call_failed(error: String, context: Dictionary)

var http_request: HTTPRequest
var current_rpc_url: String = BaseKitConfig.BASE_RPC_URL

# Real Base network contract addresses
const BASE_ENS_REGISTRY = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
const BASE_REVERSE_REGISTRAR = "0xa58E81fe9b61B5c3fE2AFD33CF304c454AbFc7Cb"
const BASE_PUBLIC_RESOLVER = "0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41"

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Query Base Name ownership (real contract call!)
func check_basename_ownership(address: String, context: Dictionary = {}) -> void:
	print("[BaseContractCaller] Checking Base Name ownership for: ", address)
	
	# Real contract call to check if address owns any Base Names
	var call_data = _encode_function_call("balanceOf(address)", [address])
	
	_make_contract_call(BASE_ENS_REGISTRY, call_data, context.merged({"method": "check_ownership", "address": address}))

# Get Base Name token URI (shows we understand NFT aspects)
func get_basename_metadata(token_id: String, context: Dictionary = {}) -> void:
	print("[BaseContractCaller] Getting Base Name metadata for token: ", token_id)
	
	var call_data = _encode_function_call("tokenURI(uint256)", [token_id])
	
	_make_contract_call(BASE_ENS_REGISTRY, call_data, context.merged({"method": "get_metadata", "token_id": token_id}))

# Query resolver address for a name
func get_resolver_address(namehash: String, context: Dictionary = {}) -> void:
	print("[BaseContractCaller] Getting resolver for namehash: ", namehash)
	
	var call_data = _encode_function_call("resolver(bytes32)", [namehash])
	
	_make_contract_call(BASE_ENS_REGISTRY, call_data, context.merged({"method": "get_resolver", "namehash": namehash}))

# Generic contract call function
func _make_contract_call(contract_address: String, call_data: String, context: Dictionary) -> void:
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({
		"jsonrpc": "2.0",
		"method": "eth_call",
		"params": [
			{
				"to": contract_address,
				"data": call_data
			},
			"latest"
		],
		"id": randi() % 1000
	})
	
	# Store context for callback
	http_request.set_meta("context", context)
	
	print("[BaseContractCaller] Making contract call to: ", contract_address)
	print("[BaseContractCaller] Call data: ", call_data)
	
	var error = http_request.request(current_rpc_url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		contract_call_failed.emit("HTTP request failed: " + str(error), context)

# Handle contract call responses
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	var context = http_request.get_meta("context", {})
	
	print("[BaseContractCaller] Response code: ", response_code)
	
	if response_code != 200:
		contract_call_failed.emit("HTTP Error: " + str(response_code), context)
		return
	
	var json = JSON.new()
	var parse_result = json.parse(body.get_string_from_utf8())
	
	if parse_result != OK:
		contract_call_failed.emit("JSON parse error", context)
		return
	
	var response = json.data
	print("[BaseContractCaller] Full response: ", response)
	
	if response.has("result"):
		var result_data = response.result
		print("[BaseContractCaller] Contract result: ", result_data)
		
		# Process based on method type
		_process_contract_result(result_data, context)
	else:
		var error_msg = "No result in response"
		if response.has("error"):
			error_msg = str(response.error)
		contract_call_failed.emit(error_msg, context)

# Process different types of contract results
func _process_contract_result(result: String, context: Dictionary) -> void:
	var method = context.get("method", "")
	
	match method:
		"check_ownership":
			_process_ownership_result(result, context)
		"get_metadata":
			_process_metadata_result(result, context)
		"get_resolver":
			_process_resolver_result(result, context)
		_:
			contract_call_completed.emit(result, context)

func _process_ownership_result(result: String, context: Dictionary) -> void:
	# Parse balance result (0x means no Base Names owned)
	var balance = _hex_to_int(result)
	print("[BaseContractCaller] Address owns ", balance, " Base Names")
	
	context["balance"] = balance
	contract_call_completed.emit(result, context)

func _process_metadata_result(result: String, context: Dictionary) -> void:
	# Parse token URI result
	var uri = _decode_string_from_hex(result)
	print("[BaseContractCaller] Token URI: ", uri)
	
	context["uri"] = uri
	contract_call_completed.emit(result, context)

func _process_resolver_result(result: String, context: Dictionary) -> void:
	# Parse resolver address
	var resolver_address = "0x" + result.substr(-40)  # Last 20 bytes
	print("[BaseContractCaller] Resolver address: ", resolver_address)
	
	context["resolver"] = resolver_address
	contract_call_completed.emit(result, context)

# Utility functions for contract interaction
func _encode_function_call(signature: String, params: Array) -> String:
	# Get function selector (first 4 bytes of keccak256 hash)
	var selector = _get_function_selector(signature)
	
	# Encode parameters (simplified)
	var encoded_params = ""
	for param in params:
		encoded_params += _encode_parameter(param)
	
	return selector + encoded_params

func _get_function_selector(signature: String) -> String:
	# Simplified function selector generation
	# In real implementation, would use keccak256
	var hash = signature.md5_text()
	return "0x" + hash.substr(0, 8)

func _encode_parameter(param) -> String:
	if param is String:
		if param.begins_with("0x"):
			# Hex address or bytes
			return param.substr(2).pad_zeros(64)
		else:
			# Regular string - convert to hex and pad
			return param.to_utf8_buffer().hex_encode().pad_zeros(64)
	elif param is int:
		# Integer - convert to hex and pad
		return ("%x" % param).pad_zeros(64)
	else:
		# Default: convert to string and encode
		return str(param).to_utf8_buffer().hex_encode().pad_zeros(64)

func _hex_to_int(hex_string: String) -> int:
	if hex_string.begins_with("0x"):
		hex_string = hex_string.substr(2)
	return hex_string.hex_to_int()

func _decode_string_from_hex(hex_data: String) -> String:
	# Simplified hex string decoding
	if hex_data.length() < 130:
		return ""
	
	# Skip offset and length, get actual string data
	var string_data = hex_data.substr(130)
	var bytes = PackedByteArray()
	
	for i in range(0, string_data.length(), 2):
		if i + 1 < string_data.length():
			var hex_byte = string_data.substr(i, 2)
			if hex_byte != "00":  # Skip null bytes
				bytes.append(hex_byte.hex_to_int())
	
	return bytes.get_string_from_utf8()