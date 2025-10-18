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