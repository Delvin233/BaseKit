using System.Threading.Tasks;
using UnityEngine.Events;

namespace BaseAuth.Core
{
    /// <summary>
    /// Interface for wallet connection functionality across different platforms and providers
    /// </summary>
    public interface IWalletConnector
    {
        /// <summary>
        /// Connects to a wallet and returns the wallet address
        /// </summary>
        /// <returns>The connected wallet address</returns>
        Task<string> ConnectWallet();
        
        /// <summary>
        /// Disconnects the current wallet connection
        /// </summary>
        void DisconnectWallet();
        
        /// <summary>
        /// Checks if a wallet is currently connected
        /// </summary>
        /// <returns>True if connected, false otherwise</returns>
        bool IsConnected();
        
        /// <summary>
        /// Gets the currently connected wallet address
        /// </summary>
        /// <returns>The wallet address or null if not connected</returns>
        string GetConnectedAddress();
        
        /// <summary>
        /// Event fired when wallet connection is successful
        /// </summary>
        UnityEvent<string> OnWalletConnected { get; }
        
        /// <summary>
        /// Event fired when wallet is disconnected
        /// </summary>
        UnityEvent OnWalletDisconnected { get; }
        
        /// <summary>
        /// Event fired when connection fails
        /// </summary>
        UnityEvent<string> OnConnectionError { get; }
    }
}