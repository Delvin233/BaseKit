class_name BaseKitConfig

# BaseKit Configuration Constants
const BASE_RPC_URL = "https://mainnet.base.org"
const BASE_CHAIN_ID = 8453
const ENS_REGISTRY = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e"
const IPFS_GATEWAY = "https://ipfs.io/ipfs/"

# Test addresses with known Base Names for development
const TEST_ADDRESSES = {
	"0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3": "vitalik.base.eth",
	"0x1234567890123456789012345678901234567890": "test.base.eth",
	"0x0987654321098765432109876543210987654321": "demo.base.eth"
}

# Fallback RPC endpoints
const BACKUP_RPC_URLS = [
	"https://base.llamarpc.com",
	"https://base-mainnet.public.blastapi.io"
]