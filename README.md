<<<<<<< HEAD
# BaseKit

A Godot SDK that enables seamless Web3 identity and login for games on Base using Base Names (ENS on Base).

## Overview

BaseKit allows Godot game developers to integrate wallet-based authentication with human-readable Base Names instead of complex wallet addresses, providing a more user-friendly Web3 gaming experience.

## Features

- 🔗 **Wallet Connection**: Support for multiple wallet providers across desktop and mobile
- 🏷️ **Base Name Resolution**: Automatically resolve wallet addresses to readable Base Names
- 🖼️ **Avatar Display**: Load and display user avatars from ENS records
- 💾 **Session Management**: Persistent login sessions across game restarts
- 🎮 **Godot Integration**: Easy-to-use scenes and scripts for quick integration
- 📱 **Cross-Platform**: Works on desktop, mobile, and web builds

## Project Structure

```
addons/
├── basekit/
│   ├── scripts/
│   │   ├── core/          # Core classes and autoloads
│   │   ├── models/        # Data models and configuration
│   │   └── utils/         # Utility classes
│   ├── scenes/            # UI scenes for easy integration
│   ├── assets/            # UI assets and textures
│   └── resources/         # Default configuration resources
```

## Getting Started

1. Copy the BaseKit addon to your Godot project's addons folder
2. Enable the BaseKit plugin in Project Settings
3. Configure your BaseKit settings with your WalletConnect Project ID
4. Add the BaseKit autoload to your scene
5. Use the provided UI scenes or create custom UI using the BaseKit API

## Requirements

- Godot 4.0 or later
- Base network access
- WalletConnect Project ID (recommended)

## License

MIT License - see LICENSE file for details
=======
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
- [Original Project Structure](base_names_project_structure.md)

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
>>>>>>> a180bdc (feat: Modified for Godot engine)
