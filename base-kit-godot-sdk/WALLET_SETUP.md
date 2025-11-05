# Wallet Setup for BaseKit Demo

## Quick Setup

1. **Copy the example config:**
   ```bash
   cp addons/basekit/wallet_config.example.gd addons/basekit/wallet_config.gd
   ```

2. **Get your private key from MetaMask:**
   - Open MetaMask
   - Click on your account name
   - Account Details → Export Private Key
   - Enter your password
   - Copy the private key

3. **Edit wallet_config.gd:**
   ```gdscript
   const PRIVATE_KEY = "0x1234567890abcdef..."  # Your actual key here
   ```

4. **Make sure you have Base Sepolia ETH:**
   - Get free testnet ETH from: https://www.alchemy.com/faucets/base-sepolia
   - Switch MetaMask to Base Sepolia network

5. **Run the demo!**

## Security Notes

- ⚠️ **wallet_config.gd is gitignored** - your private key won't be committed
- 🔒 **Only use testnet keys** - never use mainnet private keys in demos
- 🚫 **Never share your private key** - keep it secure

## Troubleshooting

**"YOUR_ACTUAL_PRIVATE_KEY_HERE" error:**
- You need to replace the placeholder in wallet_config.gd

**"Insufficient funds" error:**
- Get Base Sepolia ETH from the faucet above

**"Invalid private key" error:**
- Make sure the key starts with "0x" and is 64 characters long