using UnityEngine;

namespace BaseAuth.Models
{
    /// <summary>
    /// Configuration settings for the Base Names Login Kit
    /// </summary>
    [CreateAssetMenu(fileName = "BaseAuthConfig", menuName = "BaseAuth/Config")]
    public class BaseAuthConfig : ScriptableObject
    {
        [Header("Network Settings")]
        [Tooltip("RPC URL for Base network")]
        public string BaseRpcUrl = "https://mainnet.base.org";
        
        [Tooltip("Chain ID for Base network")]
        public int BaseChainId = 8453;
        
        [Tooltip("ENS Registry contract address on Base")]
        public string EnsRegistryAddress = "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e";
        
        [Header("Connection Settings")]
        [Tooltip("WalletConnect Project ID from WalletConnect Cloud")]
        public string WalletConnectProjectId = "";
        
        [Tooltip("Web3Auth Client ID for fallback authentication")]
        public string Web3AuthClientId = "";
        
        [Tooltip("Enable Web3Auth as fallback when WalletConnect fails")]
        public bool EnableWeb3AuthFallback = true;
        
        [Header("UI Settings")]
        [Tooltip("Default avatar sprite for users without avatars")]
        public Sprite DefaultAvatar;
        
        [Tooltip("Primary color for UI elements")]
        public Color PrimaryColor = Color.blue;
        
        [Tooltip("Show prompt to register Base Name for users without one")]
        public bool ShowBaseNamePrompt = true;
        
        [Header("Caching")]
        [Tooltip("Number of days before session expires")]
        [Range(1, 365)]
        public int SessionExpirationDays = 30;
        
        [Tooltip("Number of hours before cached Base Names expire")]
        [Range(1, 168)]
        public int NameCacheExpirationHours = 24;
        
        [Tooltip("Number of hours before cached avatars expire")]
        [Range(1, 72)]
        public int AvatarCacheExpirationHours = 6;
        
        /// <summary>
        /// Validates the configuration settings
        /// </summary>
        /// <returns>True if configuration is valid, false otherwise</returns>
        public bool ValidateConfig()
        {
            if (string.IsNullOrEmpty(BaseRpcUrl))
            {
                Debug.LogError("BaseAuthConfig: Base RPC URL is required");
                return false;
            }
            
            if (BaseChainId <= 0)
            {
                Debug.LogError("BaseAuthConfig: Valid Base Chain ID is required");
                return false;
            }
            
            if (string.IsNullOrEmpty(WalletConnectProjectId))
            {
                Debug.LogWarning("BaseAuthConfig: WalletConnect Project ID is recommended for wallet connections");
            }
            
            if (EnableWeb3AuthFallback && string.IsNullOrEmpty(Web3AuthClientId))
            {
                Debug.LogWarning("BaseAuthConfig: Web3Auth Client ID is required when fallback is enabled");
            }
            
            return true;
        }
    }
}