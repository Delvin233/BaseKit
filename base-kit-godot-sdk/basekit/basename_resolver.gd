class_name BaseNameResolver
extends Node

signal name_resolved(address: String, name: String)
signal avatar_resolved(name: String, avatar_url: String)
signal resolution_failed(address: String, error: String)

var http_request: HTTPRequest
var current_rpc_url: String = BaseKitConfig.BASE_RPC_URL

# Cache for resolved names (address -> name)
var name_cache: Dictionary = {}
var avatar_cache: Dictionary = {}

func _ready():
	# Create HTTP request node
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Main function to resolve Base Name from address
func resolve_base_name(address: String) -> void:
	print("[BaseNameResolver] Resolving Base Name for: ", address)
	
	# Check cache first
	if name_cache.has(address):
		print("[BaseNameResolver] Found in cache: ", name_cache[address])
		name_resolved.emit(address, name_cache[address])
		return
	
	# For now, use a simplified approach with known addresses
	# In a full implementation, this would query ENS contracts
	_resolve_with_fallback(address)

# Simplified resolution with fallback to test data
func _resolve_with_fallback(address: String) -> void:
	# Check if we have test data for this address
	if BaseKitConfig.TEST_ADDRESSES.has(address):
		var name = BaseKitConfig.TEST_ADDRESSES[address]
		print("[BaseNameResolver] Using test data: ", name)
		name_cache[address] = name
		name_resolved.emit(address, name)
		return
	
	# Try to resolve via RPC (simplified version)
	_query_ens_reverse_resolution(address)

# Query ENS reverse resolution (simplified)
func _query_ens_reverse_resolution(address: String) -> void:
	print("[BaseNameResolver] Querying ENS for address: ", address)
	
	# This is a simplified version - real ENS resolution is more complex
	# For now, we'll simulate the query and return formatted address
	await get_tree().create_timer(1.0).timeout
	
	# If no Base Name found, return formatted address
	var formatted_address = _format_address(address)
	print("[BaseNameResolver] No Base Name found, using formatted address: ", formatted_address)
	
	name_cache[address] = formatted_address
	name_resolved.emit(address, formatted_address)

# Format address for display (0x1234...5678)
func _format_address(address: String) -> String:
	if address.length() < 10:
		return address
	return address.substr(0, 6) + "..." + address.substr(-4)

# Get avatar for a Base Name (simplified)
func resolve_avatar(base_name: String) -> void:
	print("[BaseNameResolver] Resolving avatar for: ", base_name)
	
	# Check cache first
	if avatar_cache.has(base_name):
		avatar_resolved.emit(base_name, avatar_cache[base_name])
		return
	
	# For now, return a default avatar URL
	# In full implementation, this would query ENS avatar records
	var default_avatar = "https://api.dicebear.com/7.x/identicon/svg?seed=" + base_name
	avatar_cache[base_name] = default_avatar
	avatar_resolved.emit(base_name, default_avatar)

# Clear cache
func clear_cache() -> void:
	name_cache.clear()
	avatar_cache.clear()
	print("[BaseNameResolver] Cache cleared")

# HTTP request callback (for future ENS queries)
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("[BaseNameResolver] HTTP Response - Code: ", response_code)
	
	if response_code != 200:
		print("[BaseNameResolver] HTTP Error: ", response_code)
		return
	
	# Parse ENS response (would be implemented for real ENS queries)
	var response_text = body.get_string_from_utf8()
	print("[BaseNameResolver] Response: ", response_text)