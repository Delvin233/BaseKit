# Design Document

## Overview

BaseKit is a modular Web3 identity SDK for Godot games that provides seamless wallet authentication and Base Name resolution. The system follows a layered architecture with a central manager coordinating specialized components through Godot's signal system. The design prioritizes developer experience, platform compatibility, and graceful degradation while maintaining security best practices.

The SDK transforms complex blockchain interactions into simple GDScript APIs, enabling game developers to integrate Web3 identity features without requiring deep blockchain expertise. The architecture supports multiple authentication methods, caching strategies, and fallback mechanisms to ensure reliable operation across different network conditions.

## Architecture

### System Architecture

The BaseKit SDK follows a modular, event-driven architecture organized into distinct layers:

```
┌─────────────────────────────────────────────┐
│          Game Layer (Developer Code)        │
│  ┌─────────────┐  ┌──────────────────────┐ │
│  │   Scenes    │  │   Game Scripts       │ │
│  └─────────────┘  └──────────────────────┘ │
└────────────┬────────────────────────────────┘
             │ BaseKit API
             ▼
┌─────────────────────────────────────────────┐
│         BaseKit SDK (Plugin Layer)          │
│  ┌──────────────────────────────────────┐  │
│  │      BaseKit Manager (Singleton)     │  │
│  │         Central Coordinator          │  │
│  └──────────────────────────────────────┘  │
│                    │                        │
│     ┌──────────────┼──────────────┐        │
│     ▼              ▼              ▼         │
│  ┌────────┐  ┌─────────┐  ┌─────────────┐ │
│  │Browser │  │Smart    │  │   Session   │ │
│  │OAuth   │  │BaseName │  │   Manager   │ │
│  │Connector│  │Resolver │  │             │ │
│  └────────┘  └─────────┘  └─────────────┘ │
│       │           │              │         │
│       └───────────┼──────────────┘         │
│                   ▼                        │
│          ┌────────────────┐               │
│          │ Avatar Loader  │               │
│          └────────────────┘               │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────┐
│      Infrastructure Layer                   │
│  ┌─────────┐  ┌─────────┐  ┌───────────┐  │
│  │ Base RPC│  │   ENS   │  │   IPFS    │  │
│  │Endpoints│  │Registry │  │ Gateways  │  │
│  └─────────┘  └─────────┘  └───────────┘  │
└─────────────────────────────────────────────┘
```

### Component Responsibilities

**BaseKit Manager**: Central coordinator that exposes the public API, manages component lifecycle, routes signals between components and game code, and handles auto-login functionality.

**Browser OAuth Connector**: Manages wallet authentication through browser-based OAuth flow, runs local HTTP server for callback handling, supports MetaMask and WalletConnect protocols, and handles network switching to Base.

**Smart BaseName Resolver**: Resolves wallet addresses to Base Names using multiple strategies, implements intelligent caching with LRU eviction, provides fallback to formatted addresses, and supports both forward and reverse resolution.

**Session Manager**: Handles persistent storage of authentication sessions, manages session validation and expiration, provides secure local storage with encryption, and supports session restoration across game restarts.

**Avatar Loader**: Downloads and caches user avatars from IPFS, supports multiple image formats (PNG, JPEG, WebP), implements progressive loading with fallbacks, and provides default avatar generation.

## Components and Interfaces

### BaseKit Manager Interface

```gdscript
class_name BaseKitManager
extends Node

# Core API Methods
func connect_wallet() -> void
func disconnect_wallet() -> void
func get_connected_address() -> String
func get_base_name() -> String
func get_avatar() -> Texture2D
func is_wallet_connected() -> bool

# Signals
signal wallet_connected(address: String)
signal wallet_disconnected()
signal basename_resolved(address: String, name: String)
signal avatar_loaded(texture: Texture2D)
signal connection_error(message: String)

# Properties
var current_address: String
var current_basename: String
var current_avatar: Texture2D
var is_connected: bool
```

### Browser OAuth Connector Interface

```gdscript
class_name BrowserOAuthConnector
extends Node

# Authentication Methods
func connect_wallet() -> void
func disconnect_wallet() -> void
func is_wallet_connected() -> bool
func get_address() -> String

# Signals
signal wallet_connected(address: String)
signal wallet_disconnected()
signal connection_failed(error: String)

# Configuration
var server_port: int = 8080
var auth_session_id: String
var connected_address: String
```

### Smart BaseName Resolver Interface

```gdscript
class_name SmartBaseNameResolver
extends Node

# Resolution Methods
func resolve_base_name(address: String) -> void
func resolve_avatar(base_name: String) -> void
func clear_cache() -> void

# Signals
signal name_resolved(address: String, name: String)
signal avatar_resolved(name: String, avatar_url: String)
signal resolution_failed(address: String, error: String)

# Cache Management
var name_cache: Dictionary
var avatar_cache: Dictionary
```

### Session Manager Interface

```gdscript
class_name SessionManager
extends Node

# Session Operations
func save_session(address: String, basename: String, avatar_url: String = "") -> void
func load_session() -> bool
func clear_session() -> void
func has_valid_session() -> bool
func get_current_session() -> Dictionary

# Signals
signal session_loaded(address: String, basename: String)
signal session_saved(address: String)
signal session_cleared()
```

### Avatar Loader Interface

```gdscript
class_name AvatarLoader
extends Node

# Loading Methods
func load_avatar(url: String) -> void
func get_cached_avatar(url: String) -> Texture2D
func clear_cache() -> void

# Signals
signal avatar_loaded(texture: Texture2D)
signal avatar_failed(error: String)

# Cache Management
var avatar_cache: Dictionary
var max_cache_size: int = 50
```

## Data Models

### Session Data Model

```gdscript
class SessionData:
    var version: String = "1.0"
    var address: String
    var basename: String
    var avatar_url: String
    var timestamp: int
    var expiry: int
    
    func is_valid() -> bool:
        var current_time = Time.get_unix_time_from_system()
        return current_time < expiry and address != "" and basename != ""
    
    func to_dictionary() -> Dictionary:
        return {
            "version": version,
            "address": address,
            "basename": basename,
            "avatar_url": avatar_url,
            "timestamp": timestamp,
            "expiry": expiry
        }
```

### Configuration Model

```gdscript
class BaseKitConfig:
    # Network Configuration
    const BASE_CHAIN_ID: int = 8453
    const BASE_RPC_URL: String = "https://mainnet.base.org"
    const BACKUP_RPC_URLS: Array[String] = [
        "https://base.gateway.tenderly.co",
        "https://base.llamarpc.com"
    ]
    
    # ENS Configuration
    const ENS_REGISTRY_ADDRESS: String = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
    const BASE_ENS_RESOLVER: String = "0x6533C94869D28fAA8dF77cc63f9e2b2D6Cf77eBA"
    
    # Session Configuration
    const SESSION_EXPIRATION_DAYS: int = 1
    const SESSION_FILE_NAME: String = "basekit_session.dat"
```

### Cache Entry Model

```gdscript
class CacheEntry:
    var data: Variant
    var timestamp: int
    var access_count: int
    var ttl: int
    
    func is_expired() -> bool:
        var current_time = Time.get_unix_time_from_system()
        return current_time > (timestamp + ttl)
    
    func touch() -> void:
        access_count += 1
```

## Error Handling

### Error Classification

**Network Errors**: Connection timeouts, DNS resolution failures, HTTP error codes, RPC endpoint unavailability

**Authentication Errors**: Wallet connection failures, user rejection, invalid signatures, network mismatch

**Resolution Errors**: ENS lookup failures, invalid addresses, missing Base Names, IPFS gateway issues

**Session Errors**: Corrupted session files, expired sessions, permission issues, storage failures

**Configuration Errors**: Missing API keys, invalid RPC URLs, incorrect contract addresses, malformed settings

### Error Handling Strategy

```gdscript
# Centralized error handling with categorization
func handle_error(error_type: ErrorType, message: String, context: Dictionary = {}):
    match error_type:
        ErrorType.NETWORK:
            _handle_network_error(message, context)
        ErrorType.AUTHENTICATION:
            _handle_auth_error(message, context)
        ErrorType.RESOLUTION:
            _handle_resolution_error(message, context)
        ErrorType.SESSION:
            _handle_session_error(message, context)
        ErrorType.CONFIGURATION:
            _handle_config_error(message, context)

# Network error handling with retry logic
func _handle_network_error(message: String, context: Dictionary):
    var retry_count = context.get("retry_count", 0)
    if retry_count < MAX_RETRIES:
        await get_tree().create_timer(RETRY_DELAY * pow(2, retry_count)).timeout
        _retry_operation(context)
    else:
        _emit_error_signal(message)
        _fallback_to_cached_data(context)
```

### Graceful Degradation

**Base Name Resolution**: Falls back to formatted addresses when ENS resolution fails, uses cached results when network is unavailable, provides deterministic address formatting for consistency.

**Avatar Loading**: Uses default avatars when IPFS loading fails, generates deterministic avatars based on address/name, caches successful loads for offline access.

**Session Management**: Continues without persistence if storage fails, validates sessions on startup and clears invalid ones, provides guest mode when authentication fails.

**Network Connectivity**: Automatically tries backup RPC endpoints, implements exponential backoff for retries, provides offline mode with cached data.

## Testing Strategy

### Unit Testing Framework

```gdscript
# Test structure for BaseKit components
class TestBaseKitManager extends GutTest:
    var basekit_manager: BaseKitManager
    
    func before_each():
        basekit_manager = BaseKitManager.new()
        add_child(basekit_manager)
    
    func test_wallet_connection_success():
        var signal_emitted = false
        basekit_manager.wallet_connected.connect(func(address): signal_emitted = true)
        
        # Simulate successful connection
        basekit_manager._on_wallet_connection_success("0x1234567890123456789012345678901234567890")
        
        assert_true(signal_emitted)
        assert_eq(basekit_manager.get_connected_address(), "0x1234567890123456789012345678901234567890")
        assert_true(basekit_manager.is_wallet_connected())
```

### Integration Testing

**End-to-End Flows**: Test complete wallet connection to Base Name resolution flow, verify session persistence across component restarts, validate avatar loading with real IPFS URLs.

**Network Integration**: Test with real Base RPC endpoints, verify ENS resolution with known Base Names, test fallback behavior with unreachable endpoints.

**Platform Testing**: Validate browser OAuth flow on different platforms, test session storage on various file systems, verify UI components across different screen sizes.

### Mock Data Strategy

```gdscript
# Mock data for testing
const MOCK_ADDRESSES = {
    "0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3": {
        "basename": "alice.base.eth",
        "avatar": "ipfs://QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG"
    },
    "0x4298d42cf8a15b88ee7d9cd36ad3686f9b9fd5f6": {
        "basename": "bob.base.eth",
        "avatar": "https://api.dicebear.com/7.x/identicon/png?seed=bob"
    }
}
```

### Performance Testing

**Load Testing**: Simulate multiple concurrent resolution requests, test cache performance with large datasets, measure memory usage during extended sessions.

**Network Testing**: Test behavior under slow network conditions, validate timeout handling and retry logic, measure response times for different endpoints.

**Resource Testing**: Monitor memory usage during avatar loading, test cache eviction under memory pressure, validate cleanup of temporary resources.

### Security Testing

**Input Validation**: Test with malformed addresses and URLs, validate sanitization of user inputs, test injection attack prevention.

**Session Security**: Verify session data encryption at rest, test session hijacking prevention, validate secure token handling.

**Network Security**: Test HTTPS enforcement for all requests, validate certificate checking, test against man-in-the-middle attacks.

## Platform Considerations

### Cross-Platform Compatibility

**Desktop Platforms**: Uses system browser for OAuth authentication, stores session data in user data directory, handles file permissions appropriately.

**Web Platform**: Integrates with browser's Web3 providers, uses localStorage for session persistence, handles CORS restrictions properly.

**Mobile Platforms**: Supports mobile wallet apps through deep linking, adapts UI for touch interfaces, handles app backgrounding gracefully.

### Export Configuration

```gdscript
# Platform-specific export settings
func _get_export_options() -> Dictionary:
    return {
        "web": {
            "features": ["threads", "gdnative"],
            "custom_template": false
        },
        "desktop": {
            "features": ["threads", "gdnative"],
            "debug": true
        },
        "mobile": {
            "features": ["mobile"],
            "permissions": ["INTERNET", "WRITE_EXTERNAL_STORAGE"]
        }
    }
```

### Performance Optimization

**Memory Management**: Implements LRU cache eviction for avatars and names, uses weak references where appropriate, cleans up HTTP requests after completion.

**Network Optimization**: Batches multiple resolution requests, implements connection pooling for HTTP requests, uses compression for large responses.

**Caching Strategy**: Implements multi-level caching (memory + disk), uses cache warming for frequently accessed data, provides cache invalidation mechanisms.

**Resource Loading**: Implements progressive image loading, uses texture streaming for large avatars, provides lazy loading for non-critical resources.