class_name SessionManager
extends Node

signal session_loaded(address: String, basename: String)
signal session_saved(address: String)
signal session_cleared()

const SESSION_FILE = "user://basekit_session.dat"
const SESSION_VERSION = "1.0"

var current_session: Dictionary = {}

func _ready():
	print("[SessionManager] Initialized")

# Save current session to disk
func save_session(address: String, basename: String, avatar_url: String = "") -> void:
	print("[SessionManager] Saving session for: ", basename)
	
	var session_data = {
		"version": SESSION_VERSION,
		"address": address,
		"basename": basename,
		"avatar_url": avatar_url,
		"timestamp": Time.get_unix_time_from_system(),
		"expiry": Time.get_unix_time_from_system() + (1 * 24 * 60 * 60)  # 1 day expiry
	}
	
	var file = FileAccess.open(SESSION_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(session_data))
		file.close()
		
		current_session = session_data
		session_saved.emit(address)
		print("[SessionManager] ✅ Session saved successfully")
	else:
		print("[SessionManager] ❌ Failed to save session")

# Load session from disk
func load_session() -> bool:
	print("[SessionManager] Loading session...")
	
	if not FileAccess.file_exists(SESSION_FILE):
		print("[SessionManager] No session file found")
		return false
	
	var file = FileAccess.open(SESSION_FILE, FileAccess.READ)
	if not file:
		print("[SessionManager] Failed to open session file")
		return false
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("[SessionManager] Failed to parse session file")
		return false
	
	var session_data = json.data
	
	# Validate session
	if not _is_session_valid(session_data):
		print("[SessionManager] Session is invalid or expired")
		clear_session()
		return false
	
	current_session = session_data
	print("[SessionManager] ✅ Session loaded: ", session_data.basename)
	
	session_loaded.emit(session_data.address, session_data.basename)
	return true

# Check if session is valid and not expired
func _is_session_valid(session_data: Dictionary) -> bool:
	# Check required fields
	if not session_data.has("address") or not session_data.has("basename"):
		return false
	
	# Check version compatibility
	if not session_data.has("version") or session_data.version != SESSION_VERSION:
		print("[SessionManager] Session version mismatch")
		return false
	
	# Check expiry
	if session_data.has("expiry"):
		var current_time = Time.get_unix_time_from_system()
		if current_time > session_data.expiry:
			print("[SessionManager] Session expired")
			return false
	
	return true

# Clear current session
func clear_session() -> void:
	print("[SessionManager] Clearing session")
	
	if FileAccess.file_exists(SESSION_FILE):
		DirAccess.remove_absolute(SESSION_FILE)
	
	current_session.clear()
	session_cleared.emit()

# Get current session data
func get_current_session() -> Dictionary:
	return current_session

# Check if we have a valid session
func has_valid_session() -> bool:
	return not current_session.is_empty() and _is_session_valid(current_session)

# Get session info for display
func get_session_info() -> String:
	if not has_valid_session():
		return "No active session"
	
	var time_left = current_session.get("expiry", 0) - Time.get_unix_time_from_system()
	var days_left = int(time_left / (24 * 60 * 60))
	
	return "Logged in as " + current_session.basename + " (expires in " + str(days_left) + " days)"

# Update session with new data (e.g., avatar loaded)
func update_session(key: String, value) -> void:
	if has_valid_session():
		current_session[key] = value
		# Re-save session with updated data
		save_session(current_session.address, current_session.basename, current_session.get("avatar_url", ""))
