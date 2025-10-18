using System;
using BaseAuth.Models;

namespace BaseAuth.Core
{
    /// <summary>
    /// Interface for managing persistent authentication sessions
    /// </summary>
    public interface ISessionManager
    {
        /// <summary>
        /// Saves the current player profile session
        /// </summary>
        /// <param name="profile">The player profile to save</param>
        void SaveSession(PlayerProfile profile);
        
        /// <summary>
        /// Loads the saved session data
        /// </summary>
        /// <returns>The saved player profile or null if no valid session</returns>
        PlayerProfile LoadSession();
        
        /// <summary>
        /// Checks if the current session is valid and not expired
        /// </summary>
        /// <returns>True if session is valid, false otherwise</returns>
        bool IsSessionValid();
        
        /// <summary>
        /// Clears all session data
        /// </summary>
        void ClearSession();
        
        /// <summary>
        /// Gets whether a valid session exists
        /// </summary>
        bool HasValidSession { get; }
        
        /// <summary>
        /// Gets the last login time
        /// </summary>
        DateTime LastLoginTime { get; }
    }
}