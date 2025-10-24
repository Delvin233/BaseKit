# BaseKit - Godot Project Structure

##  Project Overview
**Goal:** Create a Godot SDK that enables seamless Web3 identity and login for games on Base using Base Names (ENS on Base).

**Core Value Proposition:** Allow Godot game developers to integrate wallet-based authentication with human-readable Base Names instead of complex addresses.

---

##  Godot Project Structure

```
base-kit-godot-sdk/
│
├── project.godot                # Main project file
├── icon.svg                     # Project icon
│
├── basekit/                     # SDK Core (Main addon)
│   ├── plugin.cfg               # Addon configuration
│   ├── wallet_connector.gd      # Base RPC calls & wallet logic
│   ├── basename_resolver.gd     # ENS lookups on Base
│   ├── session_manager.gd       # Save/load user sessions
│   ├── basekit_manager.gd       # Main API (Singleton)
│   ├── config.gd                # Network settings & constants
│   └── models/
│       ├── player_profile.gd    # User data structure
│       └── base_auth_error.gd   # Error handling
│
├── ui/                          # SDK UI Components
│   ├── login_panel.tscn         # "Connect with Base" UI
│   ├── login_panel.gd           # Login logic
│   ├── profile_display.tscn     # Show Base Name + avatar
│   ├── profile_display.gd       # Profile UI logic
│   └── themes/
│       └── basekit_theme.tres   # UI styling
│
├── coin_adventure/              # Coin Adventure Demo Game
│   ├── scenes/
│   │   ├── main_menu.tscn       # Start screen + login
│   │   ├── game_scene.tscn      # Main gameplay
│   │   ├── game_over.tscn       # Score display + restart
│   │   └── leaderboard.tscn     # High scores with Base Names
│   ├── scripts/
│   │   ├── main_menu.gd         # Menu logic + BaseKit integration
│   │   ├── player.gd            # Movement physics & controls
│   │   ├── obstacle_spawner.gd  # Cactus generation system
│   │   ├── ground_scroller.gd   # Moving background
│   │   ├── score_manager.gd     # Points + BaseKit integration
│   │   └── game_manager.gd      # Overall game state
│   └── assets/
│       ├── sprites/
│       │   ├── player_idle.png  # Player standing
│       │   ├── player_move.png  # Player moving
│       │   ├── coin.png         # Collectible coin
│       │   ├── obstacle_small.png # Small obstacle
│       │   ├── obstacle_large.png # Large obstacle
│       │   ├── ground_tile.png  # Repeating ground
│       │   └── cloud.png        # Background decoration
│       ├── sounds/
│       │   ├── collect.wav      # Coin collect sound
│       │   ├── hit.wav          # Collision sound
│       │   └── score.wav        # Point earned sound
│       └── fonts/
│           └── pixel_font.ttf   # Retro game font
│
├── examples/                    # SDK Usage Examples
│   ├── simple_integration/
│   │   ├── simple_game.tscn     # Minimal BaseKit example
│   │   └── simple_game.gd       # Basic integration code
│   └── docs/
│       ├── integration_guide.md # How to use BaseKit
│       └── api_reference.md     # Function documentation
│
├── tests/                       # Testing & Development
│   ├── test_wallet_connect.gd   # Test RPC calls
│   ├── test_basename_resolve.gd # Test ENS resolution
│   └── mock_data.gd             # Test addresses & names
│
└── docs/
    ├── README.md                # Main documentation
    ├── SETUP.md                 # Installation guide
    ├── API.md                   # Developer reference
    └── CHANGELOG.md             # Version history
```

---

##  Key Godot Files & Components

### **Core SDK Files**

**basekit/basekit_manager.gd** (AutoLoad Singleton)
```gdscript
extends Node

signal wallet_connected(address: String)
signal basename_resolved(address: String, name: String)
signal avatar_loaded(texture: Texture2D)

var wallet_connector: WalletConnector
var basename_resolver: BaseNameResolver
var session_manager: SessionManager

func connect_wallet() -> String:
    # Main API function
    pass

func get_base_name() -> String:
    # Returns current Base Name
    pass

func is_connected() -> bool:
    # Check connection status
    pass
```

**basekit/config.gd**
```gdscript
class_name BaseKitConfig

const BASE_RPC_URL = "https://mainnet.base.org"
const BASE_CHAIN_ID = 8453
const ENS_REGISTRY = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
const IPFS_GATEWAY = "https://ipfs.io/ipfs/"

# Test addresses with known Base Names
const TEST_ADDRESSES = {
    "0x1234...": "test.base.eth",
    "0x5678...": "demo.base.eth"
}
```

### **UI Components**

**ui/login_panel.tscn Structure:**
```
LoginPanel (Control)
├── Background (ColorRect)
├── VBoxContainer
│   ├── Title (Label) - "Connect with Base"
│   ├── ConnectButton (Button) - "Connect Wallet"
│   ├── StatusLabel (Label) - "Connecting..."
│   └── ErrorLabel (Label) - Error messages
```

**ui/profile_display.tscn Structure:**
```
ProfileDisplay (Control)
├── HBoxContainer
│   ├── AvatarTexture (TextureRect) - User avatar
│   └── VBoxContainer
│       ├── BaseNameLabel (Label) - "player.base.eth"
│       ├── AddressLabel (Label) - "0x1234...5678"
│       └── DisconnectButton (Button) - "Disconnect"
```

### **Demo Game Files**

**coin_adventure/scripts/player.gd**
```gdscript
extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
    # Handle movement
    var direction = Vector2.ZERO
    
    if Input.is_action_pressed("ui_right"):
        direction.x += 1
    if Input.is_action_pressed("ui_left"):
        direction.x -= 1
    if Input.is_action_pressed("ui_down"):
        direction.y += 1
    if Input.is_action_pressed("ui_up"):
        direction.y -= 1
    
    velocity = direction.normalized() * SPEED
    move_and_slide()
```

**coin_adventure/scripts/score_manager.gd**
```gdscript
extends Node

signal score_updated(new_score: int)
signal high_score_achieved(score: int, player_name: String)

var current_score = 0
var high_scores = {}

func add_points(points: int):
    current_score += points
    score_updated.emit(current_score)

func save_high_score():
    if BaseKit.is_connected():
        var player_name = BaseKit.get_base_name()
        if current_score > get_high_score(player_name):
            high_scores[player_name] = current_score
            high_score_achieved.emit(current_score, player_name)
```

---

##  Game Integration Pattern

### **Basic Integration Steps:**

1. **Add BaseKit to AutoLoad:**
   ```
   Project Settings → AutoLoad → Add basekit/basekit_manager.gd
   ```

2. **Connect Signals in Game:**
   ```gdscript
   func _ready():
       BaseKit.wallet_connected.connect(_on_wallet_connected)
       BaseKit.basename_resolved.connect(_on_basename_resolved)
   ```

3. **Show Login UI:**
   ```gdscript
   func show_login():
       var login_panel = preload("res://ui/login_panel.tscn").instantiate()
       add_child(login_panel)
   ```

4. **Display Player Info:**
   ```gdscript
   func update_player_display():
       if BaseKit.is_connected():
           player_label.text = BaseKit.get_base_name()
           avatar_texture.texture = BaseKit.get_avatar()
   ```

---

##  Godot Addon Structure

### **basekit/plugin.cfg**
```ini
[plugin]

name="BaseKit - Web3 Login SDK"
description="Wallet login and Base Name identity for Godot games"
author="BaseKit Team"
version="1.0.0"
script="plugin.gd"
```

### **Export Settings for Distribution**

**For Developers (SDK):**
- Export as Godot addon (.zip)
- Include documentation and examples
- Provide installation instructions

**For Demo (Game):**
- Export to Web (HTML5) for easy sharing
- Export to Desktop for local testing
- Include BaseKit integration showcase

---

##  Development Workflow

### **Daily File Organization:**

**Day 1:** Focus on `basekit/` core files
**Day 2:** Build `ui/` components and basic RPC
**Day 3:** Complete `basekit/basename_resolver.gd`
**Day 4:** Create entire `coin_adventure/` folder
**Day 5:** Polish `examples/` and `docs/`

### **Git Structure:**
```
main branch
├── feature/wallet-connection
├── feature/basename-resolution
├── feature/coin-adventure
└── feature/documentation
```

---

##  File Priorities by Day

### **Day 1 - Essential Files:**
- `project.godot` (project setup)
- `basekit/basekit_manager.gd` (main API)
- `basekit/config.gd` (settings)
- `ui/login_panel.tscn` (basic UI)

### **Day 2 - Core Functionality:**
- `basekit/wallet_connector.gd` (RPC calls)
- `ui/login_panel.gd` (UI logic)
- `tests/test_wallet_connect.gd` (testing)

### **Day 3 - Base Name Features:**
- `basekit/basename_resolver.gd` (ENS resolution)
- `ui/profile_display.tscn` (show results)
- `basekit/session_manager.gd` (persistence)

### **Day 4 - Game Development:**
- All files in `coin_adventure/` folder
- Game scenes, scripts, and assets
- BaseKit integration in game

### **Day 5 - Polish & Documentation:**
- `examples/` folder completion
- `docs/` folder with guides
- Final testing and cleanup

---

This structure gives you a clean, organized Godot project that's easy to navigate and perfect for both SDK development and game creation! 🎮