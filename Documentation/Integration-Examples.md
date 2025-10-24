# BaseKit Integration Examples

## Basic Integration

### Minimal Integration (5 minutes)

Add BaseKit Button to your main menu:

```gdscript
# main_menu.gd
extends Control

# Instance the BaseKit button
@onready var basekit_button = preload("res://addons/basekit/ui/basekit_button.tscn").instantiate()

func _ready():
    add_child(basekit_button)
    BaseKit.wallet_connected.connect(_on_wallet_connected)

func _on_wallet_connected(address: String):
    get_tree().change_scene_to_file("res://scenes/game.tscn")
```

### Display Base Name in-game

```gdscript
# game.gd
extends Node2D

@onready var player_name_label = $UI/PlayerName

func _ready():
    BaseKit.basename_resolved.connect(_on_name_resolved)
    
    if BaseKit.is_wallet_connected():
        BaseKit.get_base_name()

func _on_name_resolved(address: String, name: String):
    player_name_label.text = name
```

## Intermediate Integration

### Persisting Player Profiles

```gdscript
extends Node

var player_data = {}

func _ready():
    if BaseKit.is_wallet_connected():
        _load_player_profile()
    else:
        BaseKit.wallet_connected.connect(_on_wallet_connected)

func _on_wallet_connected(address: String):
    _load_player_profile()

func _load_player_profile():
    var address = BaseKit.get_connected_address()
    player_data = {
        "address": address,
        "name": BaseKit.get_cached_base_name(),
        "high_score": 0
    }
    print("Profile loaded for: ", player_data["name"])
```

### Linking BaseKit to Game Progress

```gdscript
func _on_basename_resolved(address: String, name: String):
    var save_path = "user://profiles/" + name + ".json"
    _save_progress(save_path)

func _save_progress(path: String):
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_string(JSON.stringify(player_data))
    file.close()
```

### Integrating Leaderboards

```gdscript
func record_score(score: int):
    var player = BaseKit.get_cached_base_name()
    high_scores[player] = score
    print("New score for ", player, ": ", score)
```

## Advanced Integration

### Multi-Account Support

```gdscript
var accounts = []

func add_wallet():
    BaseKit.connect_wallet()

func _on_wallet_connected(address: String):
    accounts.append(address)
```

### Cloud Synchronization

```gdscript
func sync_to_backend():
    var data = {
        "address": BaseKit.get_connected_address(),
        "basename": BaseKit.get_cached_base_name()
    }
    var request = HTTPRequest.new()
    add_child(request)
    request.request("https://api.example.com/sync", [], true, HTTPClient.METHOD_POST, JSON.stringify(data))
```

### Custom Data Binding

```gdscript
func update_profile_ui(label: Label, texture_rect: TextureRect):
    label.text = BaseKit.get_cached_base_name()
    texture_rect.texture = BaseKit.get_cached_avatar()
```

## Complete Integration Example

### Full Game Integration

```gdscript
extends Control

@onready var connect_button = $BaseKitButton
@onready var user_label = $UserLabel
@onready var avatar_rect = $AvatarRect

func _ready():
    # Connect to BaseKit signals
    BaseKit.wallet_connected.connect(_on_wallet_connected)
    BaseKit.wallet_disconnected.connect(_on_wallet_disconnected)
    BaseKit.basename_resolved.connect(_on_basename_resolved)
    BaseKit.avatar_loaded.connect(_on_avatar_loaded)
    
    # Check for existing session
    if BaseKit.is_wallet_connected():
        _update_ui_connected()

func _on_wallet_connected(address: String):
    print("Wallet connected: ", address)
    _update_ui_connected()
    
    # Request Base Name resolution
    BaseKit.get_base_name()
    
    # Request avatar
    BaseKit.get_avatar()

func _on_wallet_disconnected():
    print("Wallet disconnected")
    _update_ui_disconnected()

func _on_basename_resolved(address: String, name: String):
    print("Base Name resolved: ", name)
    user_label.text = name

func _on_avatar_loaded(texture: Texture2D):
    print("Avatar loaded")
    avatar_rect.texture = texture

func _update_ui_connected():
    user_label.show()
    avatar_rect.show()

func _update_ui_disconnected():
    user_label.hide()
    avatar_rect.hide()
```

## UI Component Examples

### Custom Wallet Display

```gdscript
extends Control
class_name CustomWalletDisplay

@onready var name_label = $NameLabel
@onready var avatar_rect = $AvatarRect
@onready var status_indicator = $StatusIndicator

func _ready():
    BaseKit.wallet_connected.connect(_on_connected)
    BaseKit.wallet_disconnected.connect(_on_disconnected)
    BaseKit.basename_resolved.connect(_on_name_resolved)
    BaseKit.avatar_loaded.connect(_on_avatar_loaded)
    
    _update_ui()

func _on_connected(address: String):
    status_indicator.modulate = Color.GREEN
    _update_ui()

func _on_disconnected():
    status_indicator.modulate = Color.RED
    _clear_ui()

func _on_name_resolved(address: String, name: String):
    name_label.text = name

func _on_avatar_loaded(texture: Texture2D):
    avatar_rect.texture = texture

func _update_ui():
    if BaseKit.is_wallet_connected():
        show()
        name_label.text = BaseKit.format_address(BaseKit.connected_address)
    else:
        hide()

func _clear_ui():
    name_label.text = ""
    avatar_rect.texture = null
```

## Best Practices

### Use Cached Data

```gdscript
# Prefer cached data for responsiveness
var name = BaseKit.get_cached_base_name()
if name.is_empty():
    BaseKit.get_base_name()  # Trigger resolution if needed
```

### Handle Network Failures Gracefully

```gdscript
func _on_connection_error(message: String):
    show_error_dialog("Connection failed: " + message)
    # Continue with offline mode or cached data
```

### Avoid Storing Private Data

```gdscript
# DON'T store sensitive data
# var private_key = "..." # NEVER DO THIS

# DO store public information only
var public_profile = {
    "address": BaseKit.get_connected_address(),
    "name": BaseKit.get_cached_base_name()
}
```

### Implement Logging

```gdscript
func _ready():
    BaseKit.debug_mode = true  # Enable for QA builds
```

### Follow MVC Principle

```gdscript
# Separate concerns
class PlayerModel:
    var address: String
    var name: String
    var avatar: Texture2D

class PlayerView:
    func update_display(model: PlayerModel):
        # Update UI elements

class PlayerController:
    func handle_wallet_connection():
        # Business logic
```

## Common Integration Patterns

| Pattern | Description | Use Case |
|---------|-------------|----------|
| Auto-Login | Automatically restores previous sessions | Casual and mobile games |
| Reactive UI | Updates dynamically using signals | Live status or multiplayer |
| Profile Sync | Combines BaseKit data with backend API | Persistent player profiles |
| Leaderboard Binding | Uses Base Names for ranking | Competitive or social games |

## Error Handling Examples

### Comprehensive Error Handling

```gdscript
func _on_connection_error(message: String):
    match message:
        "Failed to connect to wallet":
            _handle_connection_failure()
        "Session has expired":
            _handle_session_expiry()
        "Failed to resolve Base Name":
            _handle_resolution_failure()
        _:
            _handle_generic_error(message)

func _handle_connection_failure():
    show_retry_dialog()

func _handle_session_expiry():
    show_reconnect_dialog()

func _handle_resolution_failure():
    # Use formatted address as fallback
    user_label.text = BaseKit.format_address(BaseKit.get_connected_address())
```