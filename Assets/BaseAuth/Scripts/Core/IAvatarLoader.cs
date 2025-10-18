using System.Threading.Tasks;
using UnityEngine;
using UnityEngine.Events;

namespace BaseAuth.Core
{
    /// <summary>
    /// Interface for downloading and processing avatar images from various sources
    /// </summary>
    public interface IAvatarLoader
    {
        /// <summary>
        /// Loads an avatar from the given URL and converts it to a Unity Sprite
        /// </summary>
        /// <param name="url">The URL to load the avatar from (HTTP/HTTPS/IPFS)</param>
        /// <returns>The loaded avatar as a Unity Sprite</returns>
        Task<Sprite> LoadAvatar(string url);
        
        /// <summary>
        /// Gets the default avatar sprite for fallback cases
        /// </summary>
        /// <returns>The default avatar sprite</returns>
        Sprite GetDefaultAvatar();
        
        /// <summary>
        /// Clears the avatar cache
        /// </summary>
        void ClearCache();
        
        /// <summary>
        /// Event fired when avatar loading completes successfully
        /// </summary>
        UnityEvent<Sprite> OnAvatarLoaded { get; }
        
        /// <summary>
        /// Event fired when avatar loading fails
        /// </summary>
        UnityEvent<string> OnAvatarLoadError { get; }
    }
}