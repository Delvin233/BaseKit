# BaseKit

![Basekit Logo](/basekitlogocanva.jpg)

**Multi-Engine Web3 Gaming SDK powered by Base Names**

A comprehensive Web3 identity SDK that enables seamless wallet authentication for games using Base Names (ENS on Base). Currently optimized for Godot Engine with plans to expand to Unity, Unreal Engine, and other popular game engines. Transform wallet addresses into human-readable identities for your players!

## What is BaseKit?

BaseKit is a comprehensive Web3 gaming SDK that allows game developers to integrate "Sign in with Base" functionality directly into their games. **Currently available for Godot Engine** with upcoming support for Unity, Unreal Engine, and other major game engines.

Instead of showing cryptic wallet addresses like `0x1234...5678`, your players see their actual Base Names like `alice.base.eth`.

## Features

- **Wallet Connection** - Connect to Base network via RPC
- **Base Name Resolution** - Convert addresses to readable Base Names
- **Avatar Support** - Display user avatars from ENS records
- **Session Management** - Persistent login across game sessions
- **User Registry** - Automatic cross-game user tracking on Base Sepolia
- **⚡ Easy Integration** - Simple API for developers (GDScript now, more engines coming)
- **🎮 Demo Game** - Coin Adventure showcasing BaseKit integration

## Engine Support

### **Currently Supported:**

- **Godot Engine 4.x** - Full SDK with GDScript API

### **Coming Soon:**

- **Unity** - C# SDK (Q2 2024)
- **Unreal Engine** - C++/Blueprint SDK (Q3 2024)
- **GameMaker Studio** - GML SDK (Q4 2024)
- **Construct 3** - JavaScript SDK (Q4 2024)

## Demo: Coin Adventure with Web3 Identity

Our demo game is a platformer-style Coin Adventure where:

- Players sign in with their Base wallet
- Collect coins while jumping across platforms
- Game displays Base Names instead of wallet addresses
- Score tracking with Web3 identity integration
- Copy/disconnect functionality built-in

## Quick Start (Godot)

```gdscript
# Connect wallet and get Base Name
func _ready():
    BaseKit.wallet_connected.connect(_on_wallet_connected)
    BaseKit.connect_wallet()  # Automatically registers user in global registry

func _on_wallet_connected(address: String):
    var base_name = BaseKit.get_base_name()
    var avatar = BaseKit.get_avatar()
    print("Welcome, " + base_name + "!")
    # User is now part of the BaseKit ecosystem!
```

> **Note:** Unity and Unreal Engine SDKs coming soon with similar ease of integration!

## Project Structure

```
BaseKit/
├── base-kit-godot-sdk/          # Main Godot project
│   ├── addons/basekit/          # SDK core files
│   ├── examples/                # Coin Adventure platformer game
│   │   ├── scenes/              # Game scenes (player, coins, platforms)
│   │   ├── scripts/             # Game logic and BaseKit integration
│   │   └── assets/              # Sprites, sounds, fonts
│   └── tests/                   # Test scenes and scripts
├── Documentation/               # Comprehensive documentation
├── ROADMAP.md                   # Future vision
└── README.md                    # This file
```

## Development Timeline

- **Task 1:** Project setup & basic UI
- **Task 2:** RPC connection & wallet logic
- **Task 3:** Base Name resolution & avatars
- **Task 4:** Coin Adventure game development
- **Task 5:** Polish, testing & documentation

## Base Network Integration

- **Network:** Base Mainnet (Chain ID: 8453) / Base Sepolia (Chain ID: 84532)
- **RPC Endpoint:** `https://mainnet.base.org` / `https://sepolia.base.org`
- **ENS Support:** Base Names resolution
- **IPFS:** Avatar loading from decentralized storage
- **User Registry:** Smart contract tracking unique users across all BaseKit games
  - **Contract Address:** `0x440D73Ce6E944f50b8F900868517810c8ab2B451` (Base Sepolia)
  - **Live Stats:** [View on Blockscout](https://base-sepolia.blockscout.com/address/0x440D73Ce6E944f50b8F900868517810c8ab2B451?tab=contract)

## Team

- **Delvin Yamoah** - SDK structure, Base Name resolution, session logic
- **Gideon Adjei** - Wallet connection, RPC testing, UI integration

## Documentation

For comprehensive documentation, see the [Documentation/](Documentation/) folder:

- [ Requirements](Documentation/Basekit%20-%20Requirements.md) - Complete feature specifications
- [ Design](Documentation/Basekit%20-%20Design.md) - Architecture and design decisions
- [ Task Development Plan](Documentation/BaseKit%20—%205-Task%20Development%20Plan.md) - Detailed development timeline
- [ Godot Project Structure](Documentation/BaseKit%20—%20Godot%20Project%20Structure.md) - SDK organization
- [ Future Roadmap](Documentation/ROADMAP.md) - Vision for Web3 Gaming Infrastructure

## Why BaseKit?

### The Web3 Gaming Identity Crisis

**The Problem is Bigger Than You Think:**

95% of Web3 games today suffer from the same fundamental flaw: they treat players as wallet addresses, not humans. When Sarah connects her wallet to play a game, she becomes `0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3` instead of "Sarah" or "sarah.base.eth".

**This Creates Multiple Issues:**

- **Player Recognition:** Players can't recognize friends or rivals
- **Social Gaming Breaks:** Leaderboards show cryptic addresses
- **Onboarding Friction:** New users feel overwhelmed by technical complexity
- **Developer Burden:** Teams spend weeks implementing basic wallet features
- **Cross-Game Identity:** No persistent identity across different games

### Current Market Reality

**For Players:**

- Web3 games feel technical, not social
- Identity doesn't persist across games
- Addresses are impossible to remember or share

**For Developers:**

- Wallet integration takes 3-5 days minimum
- Requires blockchain expertise most teams lack
- No standardized solution across game engines
- Complex infrastructure for basic features

### The BaseKit Solution

**Transform This:**

```
Player 1: 0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3
Player 2: 0x8ba1f109551bD432803012645Hac136c34B
Player 3: 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
```

**Into This:**

```
Sarah 👩‍💻 (sarah.base.eth)
Alex 🎮 (alex.base.eth)
Jordan 🏆 (jordan.base.eth)
```

**With Just One Line of Code:**

```gdscript
BaseKit.connect_wallet()  # Connects wallet + joins ecosystem!
```

### 🌐 Cross-Game Ecosystem

**Shared User Registry:** Every game using BaseKit contributes to a unified user count, creating network effects:

- **For Players:** Same identity across all BaseKit games
- **For Developers:** Benefit from the growing BaseKit user base
- **For Ecosystem:** Stronger together - more games = more users for everyone

**Live Stats:** [Current BaseKit Users](https://base-sepolia.blockscout.com/address/0x440D73Ce6E944f50b8F900868517810c8ab2B451?tab=contract)

### Why BaseKit Wins

**1. Human-First Design**

- Base Names make players recognizable
- Avatar integration provides visual identity
- Social gaming becomes natural again

**2. Developer Experience**

- 5-minute integration vs 5-day implementation
- No blockchain knowledge required
- Works with existing game architecture

**3. Cross-Game Persistence**

- Same identity across all BaseKit games
- Build reputation and recognition
- True Web3 gaming ecosystem

**4. Built on Base**

- Fast, cheap transactions
- Coinbase ecosystem integration
- Growing developer community

**5. Multi-Engine Vision**

- Godot (available now)
- Unity, Unreal, GameMaker (coming soon)
- Same API across all platforms

### The Market Opportunity

**Gaming Market:** $180B+ annually
**Web3 Gaming:** Growing 70% year-over-year
**Developer Pain Point:** 95% struggle with Web3 integration
**Our Solution:** Make Web3 invisible to players, effortless for developers

**Result:** Better games, happier players, faster development, and true Web3 adoption in gaming.

---

_BaseKit doesn't just solve a technical problem—it solves a human problem. We're making Web3 gaming social again._

## Getting Started

### For Godot Engine (Available Now):

1. Clone this repository
2. Open `base-kit-godot-sdk/` in Godot 4.5+
3. Run the project to see the main menu
4. Connect wallet and play Coin Adventure
5. Integrate BaseKit into your own game

### For Other Engines:

- **Unity Developers:** [Join waitlist](mailto:unity@basekit.dev) for early access
- **Unreal Developers:** [Join waitlist](mailto:unreal@basekit.dev) for early access
- **Other Engines:** [Contact us](mailto:hello@basekit.dev) for custom integration

## License

MIT License - Build amazing Web3 games with BaseKit!

---

> **BaseKit** — Bringing human-readable Web3 identity to games, one Base Name at a time!
