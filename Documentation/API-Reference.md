# BaseKit API Reference

## BaseKit Manager API

The BaseKit Manager provides the main API interface for developers.

### Accessing BaseKit

```gdscript
# BaseKit is globally available as an AutoLoad singleton
# Add res://addons/basekit/basekit_manager.gd to AutoLoad as "BaseKit"
BaseKit.connect_wallet()
```

## Signals Reference

### Connection Signals

**`signal wallet_connected(address: String)`**
- **Emitted when:** Wallet successfully connects
- **Parameters:** `address` - The connected wallet address
- **Use case:** Update UI, load user data, start game

**`signal wallet_disconnected()`**
- **Emitted when:** User disconnects wallet or session expires
- **Use case:** Clear user data, return to main menu

**`signal connection_error(message: String)`**
- **Emitted when:** Connection attempt fails
- **Parameters:** `message` - Human-readable error description
- **Use case:** Display error message to user

### Identity Signals

**`signal basename_resolved(address: String, name: String)`**
- **Emitted when:** Base Name successfully resolves
- **Parameters:** 
  - `address` - Wallet address
  - `name` - Resolved Base Name (e.g., "player.base.eth")
- **Use case:** Display user's Base Name in UI

**`signal basename_resolution_failed(address: String, error: String)`**
- **Emitted when:** Base Name resolution fails
- **Parameters:**
  - `address` - Wallet address that failed to resolve
  - `error` - Error description
- **Use case:** Fallback to displaying formatted address

### Avatar Signals

**`signal avatar_loaded(texture: Texture2D)`**
- **Emitted when:** Avatar image successfully loads
- **Parameters:** `texture` - The avatar image as Texture2D
- **Use case:** Display user avatar in UI

**`signal avatar_load_failed(error: String)`**
- **Emitted when:** Avatar loading fails
- **Parameters:** `error` - Error description
- **Use case:** Display default avatar

### Session Signals

**`signal session_restored(address: String)`**
- **Emitted when:** Previous session successfully restored on startup
- **Parameters:** `address` - Restored wallet address
- **Use case:** Auto-login flow, skip connection screen

**`signal session_expired()`**
- **Emitted when:** Session token expires
- **Use case:** Prompt user to reconnect

## Methods Reference

### Connection Methods

**`func connect_wallet() -> void`**
- **Purpose:** Initiate wallet connection flow
- **Returns:** void (use signals for results)
- **Example:**
```gdscript
func _on_connect_button_pressed():
    BaseKit.connect_wallet()
```

**`func disconnect_wallet() -> void`**
- **Purpose:** Disconnect wallet and clear session
- **Side effects:** Clears session data, emits wallet_disconnected
- **Example:**
```gdscript
func _on_disconnect_button_pressed():
    BaseKit.disconnect_wallet()
```

**`func is_wallet_connected() -> bool`**
- **Purpose:** Check if wallet is currently connected
- **Returns:** true if connected, false otherwise
- **Example:**
```gdscript
func _ready():
    if BaseKit.is_wallet_connected():
        show_game_ui()
    else:
        show_connect_screen()
```

### Identity Methods

**`func get_connected_address() -> String`**
- **Purpose:** Get the currently connected wallet address
- **Returns:** Wallet address as String, or empty string if not connected
- **Example:**
```gdscript
var address = BaseKit.get_connected_address()
print("Connected as: ", address)
```

**`func get_base_name() -> void`**
- **Purpose:** Request Base Name resolution for connected address
- **Returns:** void (use basename_resolved signal for result)
- **Note:** Automatically called after wallet connection
- **Example:**
```gdscript
func refresh_user_info():
    BaseKit.get_base_name()
    
func _on_basename_resolved(address: String, name: String):
    user_label.text = name
```

**`func get_cached_base_name() -> String`**
- **Purpose:** Get cached Base Name without triggering resolution
- **Returns:** Cached Base Name or empty string
- **Example:**
```gdscript
var name = BaseKit.get_cached_base_name()
if name.is_empty():
    BaseKit.get_base_name()  # Trigger resolution
```

### Avatar Methods

**`func get_avatar() -> void`**
- **Purpose:** Request avatar loading for connected address
- **Returns:** void (use avatar_loaded signal for result)
- **Example:**
```gdscript
BaseKit.avatar_loaded.connect(_on_avatar_loaded)
BaseKit.get_avatar()

func _on_avatar_loaded(texture: Texture2D):
    avatar_sprite.texture = texture
```

**`func get_cached_avatar() -> Texture2D`**
- **Purpose:** Get cached avatar without triggering load
- **Returns:** Cached Texture2D or null
- **Example:**
```gdscript
var avatar = BaseKit.get_cached_avatar()
if avatar == null:
    BaseKit.get_avatar()
else:
    avatar_sprite.texture = avatar
```

### Utility Methods

**`func format_address(address: String) -> String`**
- **Purpose:** Format wallet address for display (0x1234…5678)
- **Parameters:** `address` - Full wallet address
- **Returns:** Formatted address string
- **Example:**
```gdscript
var formatted = BaseKit.format_address("0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb")
# Returns: "0x742d...0bEb"
```

**`func clear_cache() -> void`**
- **Purpose:** Clear all cached data (names, avatars)
- **Use case:** Force refresh of user data
- **Example:**
```gdscript
func _on_refresh_button_pressed():
    BaseKit.clear_cache()
    BaseKit.get_base_name()
    BaseKit.get_avatar()
```

## Properties Reference

### Read-Only Properties

**`var VERSION: String`**
- **Description:** Current BaseKit version
- **Example:** `print("BaseKit version: ", BaseKit.VERSION)`

**`var connected_address: String`**
- **Description:** Currently connected wallet address
- **Note:** Use get_connected_address() method instead

**`var base_name: String`**
- **Description:** Currently resolved Base Name
- **Note:** Use get_cached_base_name() method instead

### Configurable Properties

**`var debug_mode: bool = false`**
- **Description:** Enable detailed console logging
- **Example:**
```gdscript
func _ready():
    BaseKit.debug_mode = true  # Enable for development
```

**`var auto_connect: bool = true`**
- **Description:** Attempt auto-login on startup
- **Default:** true
- **Example:**
```gdscript
# Disable auto-login
BaseKit.auto_connect = false
```

## Error Codes

| Error Code | Message | Cause | Solution |
|------------|---------|-------|----------|
| CONNECTION_FAILED | "Failed to connect to wallet" | Network issue or user cancelled | Retry connection |
| INVALID_ADDRESS | "Invalid wallet address" | Malformed address | Validate input |
| RESOLUTION_FAILED | "Failed to resolve Base Name" | ENS query failed | Check network, use fallback |
| AVATAR_LOAD_FAILED | "Failed to load avatar" | IPFS unavailable | Use default avatar |
| SESSION_EXPIRED | "Session has expired" | Token timeout | Reconnect wallet |
| RPC_ERROR | "RPC call failed" | Base network issue | Check RPC endpoint |

### Error Handling Example

```gdscript
func _on_connection_error(message: String):
    match message:
        "Failed to connect to wallet":
            show_error_dialog("Please check your internet connection")
        "Session has expired":
            show_reconnect_dialog()
        _:
            show_error_dialog("An error occurred: " + message)
```