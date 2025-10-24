# BaseKit Deployment Guide

## Web Export

### HTML5 Export Configuration

**Export Settings:**
1. Open Project → Export
2. Add HTML5 export template
3. Configure the following settings:

```
Features:
- Enable "threads" if using concurrent operations
- Include BaseKit addon files

HTML:
- Custom HTML shell (optional)
- Head include for wallet scripts

Network:
- Enable HTTPS for production
- Configure CORS headers

Resources:
- Include addons/basekit/ folder
- Embed all .gd and .tscn files
```

### Web-Specific Considerations

**WalletConnect Integration:**
```html
<!-- Add to custom HTML template -->
<script src="https://unpkg.com/@walletconnect/web3-provider@1.8.0/dist/umd/index.min.js"></script>
```

**HTTPS Requirements:**
- Wallet connections require HTTPS in production
- Use SSL certificates for custom domains
- Test with `https://localhost` for development

**Browser Compatibility:**
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

### Web Deployment Checklist

- [ ] HTTPS enabled
- [ ] WalletConnect scripts loaded
- [ ] CORS headers configured
- [ ] Browser compatibility tested
- [ ] Mobile responsiveness verified
- [ ] Performance optimized

## Desktop Export

### Windows Export

**Export Settings:**
```
Application:
- Icon: Set custom icon
- File Version: Match BaseKit version
- Product Version: Your game version
- Company Name: Your company
- Product Name: Your game name

Features:
- Enable required features
- Include BaseKit addon files

Resources:
- Include all BaseKit resources
- Embed PCK file for distribution
```

**Windows-Specific Code:**
```gdscript
# Windows browser opening
func open_browser_windows(url: String):
    OS.shell_open(url)
```

### macOS Export

**Export Settings:**
```
Application:
- Bundle Identifier: com.yourcompany.yourgame
- Icon: Set .icns icon file
- Copyright: Your copyright notice

Signing:
- Enable code signing for distribution
- Set developer certificate

Notarization:
- Required for macOS 10.15+
- Submit to Apple for notarization
```

**macOS-Specific Code:**
```gdscript
# macOS browser opening
func open_browser_macos(url: String):
    OS.execute("open", [url])
```

### Linux Export

**Export Settings:**
```
Application:
- Icon: Set PNG icon
- Executable name: Your game name

Features:
- Enable X11 for desktop integration
- Include required libraries
```

**Linux-Specific Code:**
```gdscript
# Linux browser opening
func open_browser_linux(url: String):
    OS.execute("xdg-open", [url])
```

## Production Checklist

### Security Configuration

**Remove Debug Settings:**
```gdscript
# In production config
const DEBUG_MODE = false
const LOG_LEVEL = "ERROR"
const LOG_TO_FILE = false
```

**Environment Variables:**
```env
# Production .env
BASE_RPC_URL=https://mainnet.base.org
SESSION_ENCRYPTION_KEY=your_production_key_here
ENABLE_ANALYTICS=true
```

**Session Security:**
```gdscript
# Enable session encryption
const ENCRYPT_SESSION_DATA = true
const SESSION_EXPIRY_HOURS = 24  # Reasonable expiry
```

### Network Configuration

**RPC Endpoints:**
```gdscript
# Production RPC configuration
const BASE_RPC_URL = "https://mainnet.base.org"
const BACKUP_RPC_URLS = [
    "https://base.gateway.tenderly.co",
    "https://base.llamarpc.com",
    "https://base.blockpi.network/v1/rpc/public"
]
```

**IPFS Gateways:**
```gdscript
# Reliable IPFS gateways
const IPFS_GATEWAY = "https://ipfs.io/ipfs/"
const IPFS_BACKUP_GATEWAYS = [
    "https://gateway.pinata.cloud/ipfs/",
    "https://cloudflare-ipfs.com/ipfs/",
    "https://dweb.link/ipfs/"
]
```

### Performance Optimization

**Cache Configuration:**
```gdscript
# Optimized cache settings
const MAX_CACHE_SIZE = 100
const CACHE_TTL = 3600  # 1 hour
const ENABLE_CACHE_PERSISTENCE = true
```

**Network Optimization:**
```gdscript
# Connection pooling
const MAX_CONCURRENT_REQUESTS = 5
const CONNECTION_TIMEOUT = 30
const REQUEST_POOL_SIZE = 10
```

**Memory Management:**
```gdscript
# Memory limits
const AVATAR_MAX_SIZE = 512
const AVATAR_CACHE_SIZE = 50
const MAX_SESSION_SIZE = 1024  # KB
```

## Platform-Specific Deployment

### Web Hosting

**Static Hosting (Recommended):**
- Netlify
- Vercel
- GitHub Pages
- AWS S3 + CloudFront

**Server Requirements:**
- HTTPS support
- CORS headers
- Gzip compression
- CDN for global distribution

**Deployment Script:**
```bash
#!/bin/bash
# Build and deploy script
godot --headless --export "HTML5" build/index.html
aws s3 sync build/ s3://your-bucket-name/
aws cloudfront create-invalidation --distribution-id YOUR_ID --paths "/*"
```

### Desktop Distribution

**Windows Distribution:**
- Microsoft Store
- Steam
- Itch.io
- Direct download

**macOS Distribution:**
- Mac App Store
- Steam
- Itch.io
- Direct download (notarized)

**Linux Distribution:**
- Steam
- Flathub
- Snap Store
- AppImage

### Mobile Deployment (Future)

**iOS Preparation:**
```gdscript
# iOS-specific configuration
const IOS_WALLET_SCHEME = "your-app://wallet-callback"
const IOS_DEEP_LINK_HANDLER = true
```

**Android Preparation:**
```gdscript
# Android-specific configuration
const ANDROID_WALLET_INTENT = "com.yourapp.wallet"
const ANDROID_DEEP_LINK_HANDLER = true
```

## Monitoring and Analytics

### Error Tracking

**Sentry Integration:**
```gdscript
# Error reporting
func report_error(error: String, context: Dictionary):
    if ENABLE_ERROR_REPORTING:
        # Send to error tracking service
        pass
```

### Usage Analytics

**Basic Analytics:**
```gdscript
# Track key events
func track_wallet_connection():
    analytics.track("wallet_connected", {
        "timestamp": Time.get_unix_time_from_system(),
        "platform": OS.get_name()
    })

func track_basename_resolution():
    analytics.track("basename_resolved", {
        "timestamp": Time.get_unix_time_from_system(),
        "success": true
    })
```

### Performance Monitoring

**Performance Metrics:**
```gdscript
# Monitor performance
func monitor_performance():
    var metrics = {
        "memory_usage": OS.get_static_memory_usage(),
        "fps": Engine.get_frames_per_second(),
        "connection_time": last_connection_time,
        "resolution_time": last_resolution_time
    }
    # Send to monitoring service
```

## Continuous Deployment

### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy BaseKit Game
on:
  push:
    branches: [main]

jobs:
  deploy-web:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: lihop/setup-godot@v1
      - name: Export Web
        run: |
          mkdir -p build
          godot --headless --export "HTML5" build/index.html
      - name: Deploy to Netlify
        uses: nwtgck/actions-netlify@v1.2
        with:
          publish-dir: './build'
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}

  deploy-desktop:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Setup Godot
        uses: lihop/setup-godot@v1
      - name: Export Windows
        run: godot --headless --export "Windows Desktop" build/game.exe
      - name: Export Linux
        run: godot --headless --export "Linux/X11" build/game.x86_64
      - name: Create Release
        uses: actions/create-release@v1
        with:
          tag_name: v${{ github.run_number }}
          release_name: Release v${{ github.run_number }}
```

## Version Management

### Semantic Versioning

```gdscript
# Version configuration
const VERSION = "1.0.0"
const VERSION_MAJOR = 1
const VERSION_MINOR = 0
const VERSION_PATCH = 0
```

### Release Process

1. **Pre-release Testing:**
   - Run full test suite
   - Test on all target platforms
   - Verify performance benchmarks

2. **Version Bump:**
   - Update version numbers
   - Update changelog
   - Tag release in Git

3. **Build and Deploy:**
   - Generate builds for all platforms
   - Upload to distribution platforms
   - Update documentation

4. **Post-release:**
   - Monitor error reports
   - Track usage metrics
   - Plan next release

## Rollback Strategy

### Quick Rollback

```bash
# Rollback deployment
git revert HEAD
git push origin main
# Trigger redeployment
```

### Database Rollback

```gdscript
# Session data migration
func migrate_session_data(from_version: String, to_version: String):
    # Handle version compatibility
    pass
```

## Security Considerations

### Production Security

- Never commit API keys or secrets
- Use environment variables for sensitive data
- Enable session encryption
- Implement rate limiting
- Monitor for suspicious activity

### Code Obfuscation

```gdscript
# Obfuscate sensitive constants
const ENCRYPTED_CONFIG = "base64_encoded_config_here"

func get_config():
    return decrypt(ENCRYPTED_CONFIG)
```

### Network Security

- Use HTTPS everywhere
- Validate all inputs
- Implement CSRF protection
- Monitor network requests