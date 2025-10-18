# Base Names Login Kit

A Unity SDK that enables seamless Web3 identity and login for games on Base using Base Names (ENS on Base).

## Overview

The Base Names Login Kit allows Unity game developers to integrate wallet-based authentication with human-readable Base Names instead of complex wallet addresses, providing a more user-friendly Web3 gaming experience.

## Features

- 🔗 **Wallet Connection**: Support for multiple wallet providers across desktop and mobile
- 🏷️ **Base Name Resolution**: Automatically resolve wallet addresses to readable Base Names
- 🖼️ **Avatar Display**: Load and display user avatars from ENS records
- 💾 **Session Management**: Persistent login sessions across game restarts
- 🎮 **Unity Integration**: Easy-to-use prefabs and components for quick integration
- 📱 **Cross-Platform**: Works on desktop, mobile, and WebGL builds

## Project Structure

```
Assets/
├── BaseAuth/
│   ├── Scripts/
│   │   ├── Core/          # Core interfaces and base classes
│   │   ├── Models/        # Data models and configuration
│   │   └── Utils/         # Utility classes
│   ├── Prefabs/           # UI prefabs for easy integration
│   ├── UI/Sprites/        # UI assets and sprites
│   └── Resources/         # Default configuration assets
```

## Getting Started

1. Import the BaseAuth package into your Unity project
2. Configure your BaseAuthConfig asset with your WalletConnect Project ID
3. Add the BaseAuthManager prefab to your scene
4. Use the provided UI prefabs or create custom UI using the BaseAuth API

## Requirements

- Unity 2021.3 LTS or later
- Base network access
- WalletConnect Project ID (recommended)

## License

MIT License - see LICENSE file for details