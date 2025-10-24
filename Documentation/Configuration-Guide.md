# BaseKit Configuration Guide

## BaseKitConfig Overview

File: `res://addons/basekit/config.gd`

The configuration file centralizes all BaseKit settings, making it easy to switch between networks and customize behavior.

## Network Configuration

```gdscript
# Base Network Settings
const BASE_RPC_URL = "https://mainnet.base.org"
const BASE_TESTNET_RPC_URL = "https://sepolia.base.org"
const BASE_CHAIN_ID = 8453
const BASE_TESTNET_CHAIN_ID = 84532

# RPC Configuration
const RPC_TIMEOUT = 30  # seconds
const RPC_MAX_RETRIES = 3
const RPC_RETRY_DELAY = 2  # seconds
```

### Switching Networks

**For development, use testnet:**
```gdscript
# Development mode
const ACTIVE_RPC_URL = BASE_TESTNET_RPC_URL
const ACTIVE_CHAIN_ID = BASE_TESTNET_CHAIN_ID
```

**For production, use mainnet:**
```gdscript
# Production mode
const ACTIVE_RPC_URL = BASE_RPC_URL
const ACTIVE_CHAIN_ID = BASE_CHAIN_ID
```

### Custom RPC Endpoints

You can use custom RPC providers:

```gdscript
# Using Alchemy
const CUSTOM_RPC = "https://base-mainnet.g.alchemy.com/v2/YOUR_API_KEY"

# Using Infura
const CUSTOM_RPC = "https://base-mainnet.infura.io/v3/YOUR_PROJECT_ID"

# Using QuickNode
const CUSTOM_RPC = "https://your-endpoint.base.quiknode.pro/YOUR_TOKEN/"
```

## ENS Configuration

```gdscript
# ENS Registry (Base)
const ENS_REGISTRY_ADDRESS = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"

# ENS Public Resolver
const ENS_RESOLVER_ADDRESS = "0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41"

# Base Name Suffix
const BASE_NAME_SUFFIX = ".base.eth"

# Resolution Settings
const RESOLUTION_TIMEOUT = 10  # seconds
const ENABLE_REVERSE_RESOLUTION = true
const CACHE_RESOLUTION_RESULTS = true
const CACHE_TTL = 3600  # 1 hour in seconds
```

### ENS Text Records

Configure which text records to query:

```gdscript
const ENS_TEXT_RECORDS = {
    "avatar": true,      # Avatar image URL
    "description": true, # User bio/description
    "url": true,         # User website
    "email": false,      # Email address (disabled by default)
    "twitter": true,     # Twitter handle
    "github": true       # GitHub username
}
```

## Session Configuration

```gdscript
# Session Management
const SESSION_EXPIRY_HOURS = 24
const SESSION_FILE_NAME = "basekit_session.json"
const SESSION_AUTO_REFRESH = true
const SESSION_REFRESH_THRESHOLD_HOURS = 2  # Refresh if < 2hrs remaining

# Session Storage Path
const SESSION_DIRECTORY = "user://basekit/"

# Security
const ENCRYPT_SESSION_DATA = false  # Enable for production
const SESSION_ENCRYPTION_KEY = ""   # Set your encryption key
```

### Session Expiry Options

```gdscript
# Short sessions (4 hours) - for public/shared devices
const SESSION_EXPIRY_HOURS = 4

# Standard sessions (24 hours) - default
const SESSION_EXPIRY_HOURS = 24

# Long sessions (7 days) - for trusted devices
const SESSION_EXPIRY_HOURS = 168

# Persistent sessions (30 days) - maximum
const SESSION_EXPIRY_HOURS = 720
```

## Test Data Configuration

```gdscript
# Test Wallet Addresses (for local development)
const TEST_ADDRESSES = {
    "test1": "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb",
    "test2": "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "test3": "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"
}

# Test Base Names
const TEST_BASE_NAMES = {
    "0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb": "alice.base.eth",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4": "bob.base.eth",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2": "charlie.base.eth"
}

# Enable test mode
const USE_TEST_DATA = false  # Set to true for offline development
```

## Environment Variables

### Using Environment Variables (Recommended for Production)

Create a `.env` file in your project root:

```env
BASE_RPC_URL=https://mainnet.base.org
WALLETCONNECT_PROJECT_ID=your_project_id_here
ALCHEMY_API_KEY=your_alchemy_key_here
SESSION_ENCRYPTION_KEY=your_secret_key_here
```

Load in config:

```gdscript
static func get_env(key: String, default: String = "") -> String:
    if OS.has_environment(key):
        return OS.get_environment(key)
    return default

const BASE_RPC_URL = get_env("BASE_RPC_URL", "https://mainnet.base.org")
```

## Security Best Practices

- Never commit `.env` files to version control
- Add `.env` to `.gitignore`
- Use different credentials for dev/prod
- Rotate API keys regularly

## IPFS Configuration

```gdscript
# IPFS Gateway Settings
const IPFS_GATEWAY = "https://ipfs.io/ipfs/"
const IPFS_BACKUP_GATEWAYS = [
    "https://gateway.pinata.cloud/ipfs/",
    "https://cloudflare-ipfs.com/ipfs/",
    "https://dweb.link/ipfs/"
]

# Avatar Settings
const AVATAR_MAX_SIZE = 512  # pixels
const AVATAR_CACHE_SIZE = 50  # number of avatars to cache
const AVATAR_TIMEOUT = 10  # seconds
```

## Debug Configuration

```gdscript
# Debug Settings
const DEBUG_MODE = false
const LOG_LEVEL = "INFO"  # DEBUG, INFO, WARN, ERROR
const LOG_TO_FILE = false
const LOG_FILE_PATH = "user://basekit_debug.log"

# Network Debug
const LOG_RPC_CALLS = false
const LOG_ENS_QUERIES = false
const LOG_AVATAR_LOADS = false
```

## Performance Configuration

```gdscript
# Cache Settings
const MAX_CACHE_SIZE = 100
const CACHE_CLEANUP_INTERVAL = 300  # seconds
const ENABLE_CACHE_PERSISTENCE = true

# Network Settings
const MAX_CONCURRENT_REQUESTS = 5
const REQUEST_POOL_SIZE = 10
const CONNECTION_TIMEOUT = 30  # seconds
```