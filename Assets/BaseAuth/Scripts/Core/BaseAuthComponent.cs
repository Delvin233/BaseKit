using UnityEngine;
using BaseAuth.Models;

namespace BaseAuth.Core
{
    /// <summary>
    /// Abstract base class for all BaseAuth components
    /// Provides common functionality and configuration access
    /// </summary>
    public abstract class BaseAuthComponent : MonoBehaviour
    {
        [SerializeField]
        protected BaseAuthConfig config;
        
        /// <summary>
        /// Gets the configuration for this component
        /// </summary>
        public BaseAuthConfig Config 
        { 
            get 
            { 
                if (config == null)
                {
                    config = Resources.Load<BaseAuthConfig>("BaseAuthConfig");
                    if (config == null)
                    {
                        Debug.LogWarning($"{GetType().Name}: No BaseAuthConfig found. Using default settings.");
                    }
                }
                return config; 
            }
            set { config = value; }
        }
        
        /// <summary>
        /// Called when the component is initialized
        /// Override this method to implement component-specific initialization
        /// </summary>
        protected virtual void Initialize()
        {
            // Override in derived classes
        }
        
        /// <summary>
        /// Called when the component should be cleaned up
        /// Override this method to implement component-specific cleanup
        /// </summary>
        protected virtual void Cleanup()
        {
            // Override in derived classes
        }
        
        protected virtual void Awake()
        {
            Initialize();
        }
        
        protected virtual void OnDestroy()
        {
            Cleanup();
        }
        
        /// <summary>
        /// Logs a message with the component name prefix
        /// </summary>
        /// <param name="message">The message to log</param>
        protected void LogInfo(string message)
        {
            Debug.Log($"[{GetType().Name}] {message}");
        }
        
        /// <summary>
        /// Logs a warning with the component name prefix
        /// </summary>
        /// <param name="message">The warning message to log</param>
        protected void LogWarning(string message)
        {
            Debug.LogWarning($"[{GetType().Name}] {message}");
        }
        
        /// <summary>
        /// Logs an error with the component name prefix
        /// </summary>
        /// <param name="message">The error message to log</param>
        protected void LogError(string message)
        {
            Debug.LogError($"[{GetType().Name}] {message}");
        }
    }
}