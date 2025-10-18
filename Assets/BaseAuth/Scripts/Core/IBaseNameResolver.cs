using System.Threading.Tasks;
using UnityEngine.Events;

namespace BaseAuth.Core
{
    /// <summary>
    /// Interface for resolving wallet addresses to Base Names and handling ENS queries
    /// </summary>
    public interface IBaseNameResolver
    {
        /// <summary>
        /// Resolves a wallet address to its Base Name
        /// </summary>
        /// <param name="address">The wallet address to resolve</param>
        /// <returns>The Base Name or formatted address if no Base Name exists</returns>
        Task<string> ResolveBaseName(string address);
        
        /// <summary>
        /// Gets the avatar URL for a given Base Name
        /// </summary>
        /// <param name="baseName">The Base Name to query</param>
        /// <returns>The avatar URL or null if not found</returns>
        Task<string> GetAvatarUrl(string baseName);
        
        /// <summary>
        /// Formats a wallet address for display (e.g., 0x1234...5678)
        /// </summary>
        /// <param name="address">The address to format</param>
        /// <returns>The formatted address</returns>
        string FormatAddress(string address);
        
        /// <summary>
        /// Clears the resolution cache
        /// </summary>
        void ClearCache();
        
        /// <summary>
        /// Event fired when Base Name resolution completes
        /// </summary>
        UnityEvent<string, string> OnBaseNameResolved { get; } // address, name
        
        /// <summary>
        /// Event fired when resolution fails
        /// </summary>
        UnityEvent<string> OnResolutionError { get; }
    }
}