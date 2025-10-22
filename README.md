# BaseKit 🦕

**Godot SDK for wallet login powered by Base Names**

A lightweight Godot addon that enables seamless Web3 identity and authentication for games using Base Names (ENS on Base). Transform wallet addresses into human-readable identities for your players!

## 🎮 What is BaseKit?

BaseKit allows Godot developers to integrate "Sign in with Base" functionality directly into their games. Instead of showing cryptic wallet addresses like `0x1234...5678`, your players see their actual Base Names like `alice.base.eth`.

## 🚀 Features

- **🔗 Wallet Connection** - Connect to Base network via RPC
- **🏷️ Base Name Resolution** - Convert addresses to readable Base Names
- **🖼️ Avatar Support** - Display user avatars from ENS records
- **💾 Session Management** - Persistent login across game sessions
- **🎯 Easy Integration** - Simple GDScript API for developers
- **🦕 Demo Game** - Chrome Dino clone showcasing BaseKit integration

## 🎯 Demo: Chrome Dino with Web3 Identity

Our demo game is a Chrome Dino clone where:

- Players sign in with their Base wallet
- High scores show Base Names instead of "Anonymous"
- Leaderboards display actual Web3 identities
- Avatars appear next to player names

## 🛠️ Quick Start

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

## 📁 Project Structure

```
BaseKit/
├── base-kit-godot-sdk/          # Main Godot project
│   ├── basekit/                 # SDK core files
│   ├── ui/                      # Login UI components
│   ├── dino_game/               # Chrome Dino demo
│   └── examples/                # Integration examples
├── docs/                        # Documentation
└── README.md                    # This file
```

## 🎯 Development Timeline

- **Day 1:** Project setup & basic UI
- **Day 2:** RPC connection & wallet logic
- **Day 3:** Base Name resolution & avatars
- **Day 4:** Chrome Dino game development
- **Day 5:** Polish, testing & documentation

## 🌐 Base Network Integration

- **Network:** Base Mainnet (Chain ID: 8453)
- **RPC Endpoint:** `https://mainnet.base.org`
- **ENS Support:** Base Names resolution
- **IPFS:** Avatar loading from decentralized storage

## 👥 Team

- **Delvin Yamoah** - SDK structure, Base Name resolution, session logic
- **Gideon Adjei** - Wallet connection, RPC testing, UI integration

## 📚 Documentation

- [5-Day Development Plan](BaseKit%20—%205-Day%20Development%20Plan.md)
- [Godot Project Structure](BaseKit%20—%20Godot%20Project%20Structure.md)
- [🚀 Future Roadmap](ROADMAP.md) - Vision for Web3 Gaming Infrastructure

## 🎮 Why BaseKit?

**Problem:** Web3 games show ugly wallet addresses instead of human-readable identities.

**Solution:** BaseKit transforms `0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3` into `alice.base.eth` with avatar support.

**Result:** Better UX, recognizable player identities, and seamless Web3 integration.

## 🚀 Getting Started

1. Clone this repository
2. Open `base-kit-godot-sdk/` in Godot 4.5+
3. Run the Chrome Dino demo
4. Integrate BaseKit into your own game

## 📄 License

MIT License - Build amazing Web3 games with BaseKit!

---

> **BaseKit** — Bringing human-readable Web3 identity to Godot games, one Base Name at a time! 🦕⚡
