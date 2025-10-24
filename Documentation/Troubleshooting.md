# BaseKit Troubleshooting Guide

## Common Issues

### Plugin Not Found

**Issue:** BaseKit plugin not appearing in Project Settings

**Causes:**
- BaseKit not properly installed
- Plugin not enabled
- Incorrect folder structure

**Solutions:**
1. Verify BaseKit folder exists in `addons/basekit/`
2. Check `plugin.cfg` file exists
3. Enable plugin in Project Settings → Plugins
4. Restart Godot after enabling

### Wallet Not Connecting

**Issue:** Wallet connection fails or times out

**Causes:**
- Network connectivity issues
- RPC endpoint unavailable
- User cancelled connection
- Browser blocking popup

**Solutions:**
1. Check internet connection
2. Verify RPC endpoint in config
3. Try alternative RPC endpoints
4. Allow popups in browser
5. Check firewall settings

```gdscript
# Test RPC connectivity
func test_rpc_connection():
    var http = HTTPRequest.new()
    add_child(http)
    var response = await http.request("https://mainnet.base.org")
    print("RPC Status: ", response.response_code)
```

### Base Name Resolution Fails

**Issue:** Address doesn't resolve to Base Name

**Causes:**
- Address has no associated Base Name
- ENS registry unavailable
- Network timeout
- Invalid address format

**Solutions:**
1. Verify address has Base Name on Base network
2. Check ENS registry configuration
3. Use fallback to formatted address
4. Validate address format

```gdscript
# Fallback for failed resolution
func _on_basename_resolution_failed(address: String, error: String):
    user_label.text = BaseKit.format_address(address)
    print("Resolution failed: ", error)
```

### Avatar Not Loading

**Issue:** User avatar doesn't display

**Causes:**
- IPFS gateway timeout
- Invalid avatar URL
- Network connectivity
- Image format not supported

**Solutions:**
1. Try alternative IPFS gateways
2. Use default avatar fallback
3. Check image URL validity
4. Verify supported formats (PNG, JPEG, WebP)

```gdscript
# Avatar loading with fallback
func _on_avatar_load_failed(error: String):
    avatar_rect.texture = preload("res://default_avatar.png")
    print("Avatar load failed: ", error)
```

### Session Not Persisting

**Issue:** User has to reconnect every time

**Causes:**
- Session file permissions
- Storage directory not writable
- Session expiration
- Corrupted session data

**Solutions:**
1. Check file permissions in user data directory
2. Verify session expiration settings
3. Clear corrupted session files
4. Check available disk space

```gdscript
# Clear corrupted session
func clear_session():
    BaseKit.disconnect_wallet()
    var session_path = "user://basekit_session.json"
    if FileAccess.file_exists(session_path):
        DirAccess.remove_absolute(session_path)
```

## Debug Mode

### Enabling Debug Mode

```gdscript
func _ready():
    BaseKit.debug_mode = true
```

### Debug Output

When debug mode is enabled, BaseKit logs detailed information:

```
[BaseKit] Initializing components...
[BaseKit] Wallet connection initiated
[BaseKit] RPC call: eth_chainId
[BaseKit] Response: {"result": "0x2105"}
[BaseKit] Base Name resolution for: 0x742d...
[BaseKit] ENS query result: alice.base.eth
[BaseKit] Avatar loading from: ipfs://Qm...
[BaseKit] Session saved successfully
```

### Debug Configuration

```gdscript
# In config.gd
const DEBUG_MODE = true
const LOG_LEVEL = "DEBUG"  # DEBUG, INFO, WARN, ERROR
const LOG_TO_FILE = true
const LOG_FILE_PATH = "user://basekit_debug.log"
```

## Error Messages

### Connection Errors

| Error | Meaning | Solution |
|-------|---------|----------|
| "Failed to connect to wallet" | Network or user cancellation | Check connection, retry |
| "Invalid chain ID" | Wrong network | Switch to Base network |
| "RPC endpoint unavailable" | Server issues | Try backup endpoints |
| "Authentication timeout" | Process took too long | Retry connection |

### Resolution Errors

| Error | Meaning | Solution |
|-------|---------|----------|
| "Failed to resolve Base Name" | ENS lookup failed | Use formatted address |
| "Invalid address format" | Malformed address | Validate input |
| "ENS registry unavailable" | Network issues | Retry later |
| "Resolution timeout" | Query took too long | Increase timeout |

### Session Errors

| Error | Meaning | Solution |
|-------|---------|----------|
| "Session has expired" | Token timeout | Reconnect wallet |
| "Failed to save session" | Storage issues | Check permissions |
| "Corrupted session data" | Invalid file | Clear session |
| "Session file not found" | Missing file | Normal for first run |

## FAQ

### Q: Can I use BaseKit offline?

**A:** Yes, in test mode with cached data. Set `USE_TEST_DATA = true` in config.

### Q: Why is Base Name resolution slow?

**A:** First resolution queries the blockchain. Subsequent calls use cache for speed.

### Q: Can I customize the UI components?

**A:** Yes, you can modify the provided UI scenes or create custom components using BaseKit signals.

### Q: Does BaseKit store private keys?

**A:** No, BaseKit never stores private keys. It only stores session tokens for authentication.

### Q: What happens if the RPC endpoint goes down?

**A:** BaseKit automatically tries backup endpoints configured in the settings.

### Q: Can I use BaseKit with other networks?

**A:** Currently BaseKit is optimized for Base network, but can be configured for other EVM chains.

## Performance Issues

### Slow Avatar Loading

**Symptoms:** Avatars take long time to load

**Solutions:**
1. Use faster IPFS gateways
2. Implement progressive loading
3. Reduce avatar size limits
4. Enable avatar caching

```gdscript
# Optimize avatar loading
const AVATAR_MAX_SIZE = 256  # Reduce from 512
const AVATAR_TIMEOUT = 5     # Reduce from 10
```

### High Memory Usage

**Symptoms:** Game uses excessive memory

**Solutions:**
1. Limit cache sizes
2. Clear unused avatars
3. Implement cache eviction
4. Monitor memory usage

```gdscript
# Memory optimization
const MAX_CACHE_SIZE = 25    # Reduce from 50
const CACHE_CLEANUP_INTERVAL = 60  # More frequent cleanup
```

### Network Timeouts

**Symptoms:** Frequent timeout errors

**Solutions:**
1. Increase timeout values
2. Use faster RPC endpoints
3. Implement retry logic
4. Check network stability

```gdscript
# Timeout configuration
const RPC_TIMEOUT = 45       # Increase from 30
const RPC_MAX_RETRIES = 5    # Increase from 3
```

## Platform-Specific Issues

### Web Export Issues

**Issue:** BaseKit doesn't work in browser

**Solutions:**
1. Enable required features in export settings
2. Check CORS policies
3. Verify HTTPS requirements
4. Test in different browsers

### Desktop Export Issues

**Issue:** OAuth popup doesn't open

**Solutions:**
1. Check system browser settings
2. Verify popup permissions
3. Test with different browsers
4. Check firewall settings

### Mobile Export Issues

**Issue:** Wallet connection fails on mobile

**Solutions:**
1. Use mobile-friendly wallet apps
2. Implement deep linking
3. Test on actual devices
4. Check mobile browser compatibility

## Support Resources

### Getting Help

1. **GitHub Issues:** Report bugs and feature requests
2. **Documentation:** Check comprehensive guides
3. **Community:** Join Discord/Telegram for support
4. **Examples:** Review integration examples

### Reporting Issues

When reporting issues, include:

1. **Environment:**
   - Godot version
   - BaseKit version
   - Operating system
   - Export platform

2. **Steps to reproduce:**
   - Detailed reproduction steps
   - Expected vs actual behavior
   - Screenshots/videos if applicable

3. **Logs:**
   - Console output
   - Debug logs
   - Error messages

4. **Configuration:**
   - Config settings
   - Network settings
   - Custom modifications

### Debug Information Collection

```gdscript
# Collect debug info
func collect_debug_info():
    var info = {
        "basekit_version": BaseKit.VERSION,
        "godot_version": Engine.get_version_info(),
        "platform": OS.get_name(),
        "connected": BaseKit.is_wallet_connected(),
        "address": BaseKit.get_connected_address(),
        "config": BaseKitConfig.get_debug_info()
    }
    print("Debug Info: ", JSON.stringify(info))
```