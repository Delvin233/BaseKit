class_name BaseKitConfig
extends RefCounted

# BaseKit Configuration Constants

# Base Network Configuration
const BASE_CHAIN_ID: int = 8453
const BASE_RPC_URL: String = "https://mainnet.base.org"
const BACKUP_RPC_URLS: Array[String] = [
	"https://base.gateway.tenderly.co",
	"https://base.llamarpc.com"
]

# ENS Configuration
const ENS_REGISTRY_ADDRESS: String = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
const BASE_ENS_RESOLVER: String = "0x6533C94869D28fAA8dF77cc63f9e2b2D6Cf77eBA"

# API Configuration
const ALCHEMY_API_KEY: String = "demo"  # Replace with real key
const ALCHEMY_BASE_URL: String = "https://base-mainnet.g.alchemy.com/nft/v3/"

# Session Configuration
const SESSION_EXPIRATION_DAYS: int = 1
const SESSION_FILE_NAME: String = "basekit_session.dat"

# Test addresses for demo (remove in production)
const TEST_ADDRESSES: Dictionary = {
	"0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3": "alice.base.eth",
	"0x4298d42cf8a15b88ee7d9cd36ad3686f9b9fd5f6": "delviny233.base.eth"
}