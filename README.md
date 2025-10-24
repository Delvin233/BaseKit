# BaseKit 

**Multi-Engine Web3 Gaming SDK powered by Base Names**

A comprehensive Web3 identity SDK that enables seamless wallet authentication for games using Base Names (ENS on Base). Currently optimized for Godot Engine with plans to expand to Unity, Unreal Engine, and other popular game engines. Transform wallet addresses into human-readable identities for your players!

## What is BaseKit?

BaseKit is a comprehensive Web3 gaming SDK that allows game developers to integrate "Sign in with Base" functionality directly into their games. **Currently available for Godot Engine** with upcoming support for Unity, Unreal Engine, and other major game engines.

Instead of showing cryptic wallet addresses like `0x1234...5678`, your players see their actual Base Names like `alice.base.eth`.

##  Features

- ** Wallet Connection** - Connect to Base network via RPC
- ** Base Name Resolution** - Convert addresses to readable Base Names
- ** Avatar Support** - Display user avatars from ENS records
- ** Session Management** - Persistent login across game sessions
- ** Easy Integration** - Simple API for developers (GDScript now, more engines coming)
- ** Demo Game** - Coin Adventure showcasing BaseKit integration

##  Engine Support

###  **Currently Supported:**
- **Godot Engine 4.x** - Full SDK with GDScript API

###  **Coming Soon:**
- **Unity** - C# SDK (Q2 2024)
- **Unreal Engine** - C++/Blueprint SDK (Q3 2024)
- **GameMaker Studio** - GML SDK (Q4 2024)
- **Construct 3** - JavaScript SDK (Q4 2024)

##  Demo: Chrome Dino with Web3 Identity

Our demo game is a Coin Adventure where:

- Players sign in with their Base wallet
- High scores show Base Names instead of "Anonymous"
- Leaderboards display actual Web3 identities
- Avatars appear next to player names

##  Quick Start (Godot)

```gdscript
# Connect wallet and get Base Name
func _ready():
    BaseKit.wallet_connected.connect(_on_wallet_connected)
    BaseKit.connect_wallet()

func _on_wallet_connected(address: String):
    var base_name = BaseKit.get_base_name()
    var avatar = BaseKit.get_avatar()
    print("Welcome, " + base_name + "!")
```

> **Note:** Unity and Unreal Engine SDKs coming soon with similar ease of integration!

##  Project Structure

```
BaseKit/
├── base-kit-godot-sdk/          # Main Godot project
│   ├── basekit/                 # SDK core files
│   ├── ui/                      # Login UI components
│   ├── tests/                   # Test scenes and scripts
│   ├── examples/                # Integration examples
│   └── simple_demo.tscn         # Main demo
├── docs/                        # Documentation
├── ROADMAP.md                   # Future vision
└── README.md                    # This file
```

##  Development Timeline

- **Task 1:** Project setup & basic UI
- **Task 2:** RPC connection & wallet logic
- **Task 3:** Base Name resolution & avatars
- **Task 4:** Coin Adventure game development
- **Task 5:** Polish, testing & documentation

##  Base Network Integration

- **Network:** Base Mainnet (Chain ID: 8453)
- **RPC Endpoint:** `https://mainnet.base.org`
- **ENS Support:** Base Names resolution
- **IPFS:** Avatar loading from decentralized storage

##  Team

- **Delvin Yamoah** - SDK structure, Base Name resolution, session logic
- **Gideon Adjei** - Wallet connection, RPC testing, UI integration

##  Documentation

For comprehensive documentation, see the [Documentation/](Documentation/) folder:

- [ Requirements](Documentation/Basekit%20-%20Requirements.md) - Complete feature specifications
- [ Design](Documentation/Basekit%20-%20Design.md) - Architecture and design decisions
- [ Task Development Plan](Documentation/BaseKit%20—%205-Task%20Development%20Plan.md) - Detailed development timeline
- [ Godot Project Structure](Documentation/BaseKit%20—%20Godot%20Project%20Structure.md) - SDK organization
- [ Future Roadmap](Documentation/ROADMAP.md) - Vision for Web3 Gaming Infrastructure

##  Why BaseKit?

**Problem:** Web3 games show ugly wallet addresses instead of human-readable identities.

**Solution:** BaseKit transforms `0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3` into `alice.base.eth` with avatar support.

**Result:** Better UX, recognizable player identities, and seamless Web3 integration.

##  Getting Started

### For Godot Engine (Available Now):
1. Clone this repository
2. Open `base-kit-godot-sdk/` in Godot 4.5+
3. Run the Coin Adventure demo
4. Integrate BaseKit into your own game

### For Other Engines:
- **Unity Developers:** [Join waitlist](mailto:unity@basekit.dev) for early access
- **Unreal Developers:** [Join waitlist](mailto:unreal@basekit.dev) for early access
- **Other Engines:** [Contact us](mailto:hello@basekit.dev) for custom integration

##  License

MIT License - Build amazing Web3 games with BaseKit!

---

> **BaseKit** — Bringing human-readable Web3 identity to games, one Base Name at a time!
