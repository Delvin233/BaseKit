class_name BaseKitErrorHandler

enum ErrorType {
	NETWORK_ERROR,
	RPC_ERROR,
	WALLET_ERROR,
	PARSING_ERROR,
	TIMEOUT_ERROR
}

static func handle_error(type: ErrorType, message: String, details: String = "") -> String:
	var formatted_message = ""
	
	match type:
		ErrorType.NETWORK_ERROR:
			formatted_message = "Network Error: " + message
		ErrorType.RPC_ERROR:
			formatted_message = "RPC Error: " + message
		ErrorType.WALLET_ERROR:
			formatted_message = "Wallet Error: " + message
		ErrorType.PARSING_ERROR:
			formatted_message = "Parsing Error: " + message
		ErrorType.TIMEOUT_ERROR:
			formatted_message = "Timeout Error: " + message
	
	if details != "":
		formatted_message += " (" + details + ")"
	
	print("[BaseKit Error] ", formatted_message)
	return formatted_message

static func is_retryable_error(type: ErrorType) -> bool:
	match type:
		ErrorType.NETWORK_ERROR, ErrorType.TIMEOUT_ERROR:
			return true
		_:
			return false