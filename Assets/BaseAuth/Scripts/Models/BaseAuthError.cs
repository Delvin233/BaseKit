using System;

namespace BaseAuth.Models
{
    /// <summary>
    /// Represents an error that occurred during BaseAuth operations
    /// </summary>
    [Serializable]
    public class BaseAuthError
    {
        /// <summary>
        /// Types of errors that can occur in BaseAuth
        /// </summary>
        public enum ErrorType
        {
            WalletConnection,
            NameResolution,
            AvatarLoading,
            SessionManagement,
            NetworkError,
            ConfigurationError,
            ValidationError
        }
        
        /// <summary>
        /// The type of error that occurred
        /// </summary>
        public ErrorType Type;
        
        /// <summary>
        /// User-friendly error message
        /// </summary>
        public string Message;
        
        /// <summary>
        /// Detailed error information for debugging
        /// </summary>
        public string Details;
        
        /// <summary>
        /// Whether this error can be retried
        /// </summary>
        public bool IsRetryable;
        
        /// <summary>
        /// The underlying exception if available
        /// </summary>
        public Exception Exception;
        
        public BaseAuthError(ErrorType type, string message, string details = null, bool isRetryable = false, Exception exception = null)
        {
            Type = type;
            Message = message;
            Details = details;
            IsRetryable = isRetryable;
            Exception = exception;
        }
        
        /// <summary>
        /// Creates a wallet connection error
        /// </summary>
        public static BaseAuthError WalletConnectionError(string message, string details = null, bool isRetryable = true)
        {
            return new BaseAuthError(ErrorType.WalletConnection, message, details, isRetryable);
        }
        
        /// <summary>
        /// Creates a name resolution error
        /// </summary>
        public static BaseAuthError NameResolutionError(string message, string details = null, bool isRetryable = true)
        {
            return new BaseAuthError(ErrorType.NameResolution, message, details, isRetryable);
        }
        
        /// <summary>
        /// Creates an avatar loading error
        /// </summary>
        public static BaseAuthError AvatarLoadingError(string message, string details = null, bool isRetryable = true)
        {
            return new BaseAuthError(ErrorType.AvatarLoading, message, details, isRetryable);
        }
        
        /// <summary>
        /// Creates a network error
        /// </summary>
        public static BaseAuthError NetworkError(string message, string details = null, bool isRetryable = true)
        {
            return new BaseAuthError(ErrorType.NetworkError, message, details, isRetryable);
        }
        
        public override string ToString()
        {
            return $"[{Type}] {Message}" + (string.IsNullOrEmpty(Details) ? "" : $" - {Details}");
        }
    }
}