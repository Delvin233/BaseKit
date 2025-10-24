# BaseKit Testing Strategy

## Testing Overview

BaseKit uses a comprehensive testing approach including unit tests, integration tests, and end-to-end testing to ensure reliability across different scenarios.

## Unit Testing

### Testing Framework

```gdscript
# Test structure for BaseKit components
# File: tests/test_basekit_manager.gd
class TestBaseKitManager extends GutTest:
    var basekit_manager: BaseKitManager
    
    func before_each():
        basekit_manager = preload("res://addons/basekit/basekit_manager.gd").new()
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

### Component Testing

**BaseKit Manager Tests:**
```gdscript
func test_connect_wallet():
    basekit_manager.connect_wallet()
    # Verify connection flow initiated

func test_disconnect_wallet():
    basekit_manager.disconnect_wallet()
    # Verify cleanup and signals

func test_get_base_name():
    basekit_manager.get_base_name()
    # Verify resolution request
```

**Session Manager Tests:**
```gdscript
func test_save_session():
    var session_data = {"address": "0x123", "name": "test.base.eth"}
    session_manager.save_session(session_data)
    # Verify file creation and content

func test_load_session():
    var loaded_session = session_manager.load_session()
    # Verify data integrity

func test_session_expiry():
    # Test expired session handling
```

## Integration Testing

### End-to-End Flows

**Complete Wallet Connection Flow:**
```gdscript
func test_full_connection_flow():
    # 1. Initiate connection
    BaseKit.connect_wallet()
    
    # 2. Simulate OAuth success
    _simulate_oauth_callback("test_token")
    
    # 3. Verify wallet connected signal
    await BaseKit.wallet_connected
    
    # 4. Verify Base Name resolution
    await BaseKit.basename_resolved
    
    # 5. Verify avatar loading
    await BaseKit.avatar_loaded
    
    # 6. Verify session persistence
    assert_true(session_manager.has_valid_session())
```

### Network Integration

**Real Base RPC Testing:**
```gdscript
func test_base_rpc_connection():
    var rpc_client = BaseRPCClient.new()
    var result = await rpc_client.call_method("eth_chainId")
    assert_eq(result, "0x2105")  # Base chain ID
```

**ENS Resolution Testing:**
```gdscript
func test_ens_resolution():
    var resolver = BaseNameResolver.new()
    var name = await resolver.resolve_name("0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3")
    assert_true(name.ends_with(".base.eth"))
```

## Mock Data Strategy

### Test Data

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

### Mock Services

```gdscript
class MockWalletConnector extends WalletConnector:
    func connect_wallet():
        # Simulate successful connection
        await get_tree().create_timer(0.1).timeout
        wallet_connected.emit(MOCK_ADDRESSES.keys()[0])

class MockBaseNameResolver extends BaseNameResolver:
    func resolve_name(address: String):
        if address in MOCK_ADDRESSES:
            var data = MOCK_ADDRESSES[address]
            name_resolved.emit(address, data.basename)
        else:
            resolution_failed.emit(address, "Name not found")
```

## Manual Testing

### Test Scenarios

**Connection Testing:**
1. Test wallet connection with MetaMask
2. Test connection cancellation
3. Test network switching
4. Test connection timeout

**Resolution Testing:**
1. Test Base Name resolution for known addresses
2. Test fallback for addresses without names
3. Test avatar loading from IPFS
4. Test default avatar fallback

**Session Testing:**
1. Test session persistence across restarts
2. Test session expiration
3. Test session clearing
4. Test invalid session handling

### Test Checklist

- [ ] Wallet connects successfully
- [ ] Base Name resolves correctly
- [ ] Avatar loads and displays
- [ ] Session persists across restarts
- [ ] Error messages are user-friendly
- [ ] UI updates reactively
- [ ] Performance is acceptable
- [ ] Memory usage is reasonable

## Network Testing

### RPC Endpoint Testing

```gdscript
func test_rpc_endpoints():
    var endpoints = [
        "https://mainnet.base.org",
        "https://base.gateway.tenderly.co",
        "https://base.llamarpc.com"
    ]
    
    for endpoint in endpoints:
        var client = HTTPRequest.new()
        var response = await client.request(endpoint)
        assert_eq(response.response_code, 200)
```

### Fallback Testing

```gdscript
func test_rpc_fallback():
    # Simulate primary endpoint failure
    BaseKitConfig.BASE_RPC_URL = "https://invalid-endpoint.com"
    
    # Verify fallback to secondary endpoint
    var result = await BaseKit.connect_wallet()
    assert_true(result.success)
```

### Latency Testing

```gdscript
func test_network_latency():
    var start_time = Time.get_unix_time_from_system()
    await BaseKit.get_base_name()
    var end_time = Time.get_unix_time_from_system()
    
    var latency = end_time - start_time
    assert_lt(latency, 5.0)  # Should complete within 5 seconds
```

## Performance Testing

### Load Testing

```gdscript
func test_concurrent_resolutions():
    var addresses = MOCK_ADDRESSES.keys()
    var tasks = []
    
    for address in addresses:
        tasks.append(BaseKit.resolve_name(address))
    
    var results = await Promise.all(tasks)
    assert_eq(results.size(), addresses.size())
```

### Memory Testing

```gdscript
func test_memory_usage():
    var initial_memory = OS.get_static_memory_usage()
    
    # Load many avatars
    for i in range(100):
        await BaseKit.load_avatar("test_url_" + str(i))
    
    var final_memory = OS.get_static_memory_usage()
    var memory_increase = final_memory - initial_memory
    
    # Should not exceed reasonable limit
    assert_lt(memory_increase, 100 * 1024 * 1024)  # 100MB
```

### Cache Testing

```gdscript
func test_cache_performance():
    # First resolution (cache miss)
    var start_time = Time.get_unix_time_from_system()
    await BaseKit.resolve_name("0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3")
    var cache_miss_time = Time.get_unix_time_from_system() - start_time
    
    # Second resolution (cache hit)
    start_time = Time.get_unix_time_from_system()
    await BaseKit.resolve_name("0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3")
    var cache_hit_time = Time.get_unix_time_from_system() - start_time
    
    # Cache hit should be significantly faster
    assert_lt(cache_hit_time, cache_miss_time * 0.1)
```

## Test Data

### Known Test Addresses

```gdscript
const TEST_ADDRESSES = {
    # Addresses with confirmed Base Names
    "0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3": "alice.base.eth",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4": "bob.base.eth",
    
    # Addresses without Base Names (for fallback testing)
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2": null,
    
    # Invalid addresses (for error testing)
    "0xinvalid": null,
    "": null
}
```

### Test Avatar URLs

```gdscript
const TEST_AVATARS = {
    "valid_ipfs": "ipfs://QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG",
    "valid_http": "https://api.dicebear.com/7.x/identicon/png?seed=test",
    "invalid_url": "https://invalid-domain.com/avatar.png",
    "malformed_url": "not-a-url"
}
```

## Continuous Integration

### Automated Test Pipeline

```yaml
# .github/workflows/test.yml
name: BaseKit Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: lihop/setup-godot@v1
      - name: Run Unit Tests
        run: godot --headless -s addons/gut/gut_cmdln.gd
      - name: Run Integration Tests
        run: godot --headless -s test_runner.gd
```

### Test Coverage

Target coverage goals:
- Unit tests: 90%+ code coverage
- Integration tests: All major user flows
- Manual tests: All UI interactions
- Performance tests: All critical paths