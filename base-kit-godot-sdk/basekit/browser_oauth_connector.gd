class_name BrowserOAuthConnector
extends Node

signal wallet_connected(address: String)
signal wallet_disconnected()
signal connection_failed(error: String)

var http_server: TCPServer
var connected_address: String = ""
var auth_session_id: String = ""
var server_port: int = 8080

func _ready():
	print("[BrowserOAuth] Initialized")

# Start OAuth-style wallet connection
func connect_wallet() -> void:
	print("[BrowserOAuth] Starting browser OAuth connection...")
	
	# Generate unique session ID
	auth_session_id = _generate_session_id()
	
	# Start local HTTP server to receive callback
	_start_callback_server()
	
	# Wait longer for server to be ready, then open browser
	await get_tree().create_timer(1.0).timeout
	if http_server and http_server.is_listening():
		_open_browser_auth()
	else:
		print("[BrowserOAuth] Server not ready, connection failed")
		connection_failed.emit("Failed to start local server")

# Generate unique session ID
func _generate_session_id() -> String:
	var session = ""
	for i in range(16):
		session += "%02x" % randi_range(0, 255)
	return session

# Start local HTTP server for OAuth callback
func _start_callback_server() -> void:
	http_server = TCPServer.new()
	
	# Try ports 8080-8090 until we find one available
	var port_found = false
	for port in range(8080, 8091):
		if http_server.listen(port) == OK:
			server_port = port
			port_found = true
			print("[BrowserOAuth] Callback server started on port ", port)
			break
		else:
			print("[BrowserOAuth] Port ", port, " is busy, trying next...")
	
	if not port_found:
		print("[BrowserOAuth] Failed to find available port (8080-8090)")
		connection_failed.emit("Port conflict: All ports 8080-8090 are busy. Please close other applications using these ports.")
		return
	
	# Start polling for connections
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.1
	timer.timeout.connect(_poll_server)
	timer.start()

# Poll for incoming HTTP connections
func _poll_server() -> void:
	if not http_server:
		return
	
	if http_server.is_connection_available():
		var client = http_server.take_connection()
		_handle_callback_request(client)

# Handle HTTP requests
func _handle_callback_request(client: StreamPeerTCP) -> void:
	# Read HTTP request
	var request = ""
	while client.get_available_bytes() > 0:
		request += client.get_string(client.get_available_bytes())
	
	print("[BrowserOAuth] Received request: ", request.substr(0, 50))
	
	# Route requests
	if "GET /auth" in request:
		# Serve auth page
		_serve_auth_page(client)
	elif "GET /callback" in request and "address=" in request:
		# Handle wallet callback
		_handle_wallet_callback(client, request)
	else:
		# 404 response
		_serve_404(client)

# Serve authentication page
func _serve_auth_page(client: StreamPeerTCP) -> void:
	var response = "HTTP/1.1 200 OK\nContent-Type: text/html\n\n" + _get_auth_html()
	client.put_data(response.to_utf8_buffer())
	client.disconnect_from_host()

# Handle wallet connection callback
func _handle_wallet_callback(client: StreamPeerTCP, request: String) -> void:
	# Parse wallet address from URL
	var address_start = request.find("address=") + 8
	var address_end = request.find("&", address_start)
	if address_end == -1:
		address_end = request.find(" ", address_start)
	
	var address = request.substr(address_start, address_end - address_start)
	
	# Send success response
	var response = """HTTP/1.1 200 OK
Content-Type: text/html

<!DOCTYPE html>
<html>
<head><title>BaseKit - Wallet Connected</title></head>
<body style="font-family: Arial; text-align: center; padding: 50px; background: #1a1a1a; color: white;">
	<h1>🎉 Wallet Connected!</h1>
	<p>Address: """ + address + """</p>
	<p>You can close this tab and return to the game.</p>
</body>
</html>"""
	
	client.put_data(response.to_utf8_buffer())
	client.disconnect_from_host()
	
	# Emit success
	_on_wallet_connected(address)

# Serve 404 page
func _serve_404(client: StreamPeerTCP) -> void:
	var response = """HTTP/1.1 404 Not Found
Content-Type: text/html

<!DOCTYPE html>
<html>
<head><title>BaseKit - Not Found</title></head>
<body style="font-family: Arial; text-align: center; padding: 50px;">
	<h1>404 - Not Found</h1>
	<p>Go to <a href="/auth">/auth</a> to connect wallet</p>
</body>
</html>"""
	
	client.put_data(response.to_utf8_buffer())
	client.disconnect_from_host()

# Open browser to authentication page
func _open_browser_auth() -> void:
	var auth_url = "http://localhost:" + str(server_port) + "/auth"
	print("[BrowserOAuth] Server listening on port: ", server_port)
	print("[BrowserOAuth] Server is_listening: ", http_server.is_listening())
	print("[BrowserOAuth] Opening browser to: ", auth_url)
	OS.shell_open(auth_url)

# Generate authentication HTML page
func _get_auth_html() -> String:
	return """<!DOCTYPE html>
<html>
<head>
	<title>BaseKit - Connect Wallet</title>
	<style>
		body { font-family: Arial; text-align: center; padding: 50px; background: #1a1a1a; color: white; }
		.container { max-width: 500px; margin: 0 auto; }
		button { background: #0066cc; color: white; border: none; padding: 15px 30px; font-size: 18px; border-radius: 8px; cursor: pointer; margin: 10px; }
		button:hover { background: #0052a3; }
		.status { margin: 20px 0; padding: 15px; border-radius: 8px; }
		.loading { background: #333; }
		.success { background: #006600; }
		.error { background: #cc0000; }
	</style>
</head>
<body>
	<div class="container">
		<h1>🦕 BaseKit Wallet Connection</h1>
		<p>Connect your MetaMask wallet to play with your Base Name identity!</p>
		
		<div id="status" class="status loading">
			<p id="statusText">Checking for MetaMask...</p>
		</div>
		
		<button id="connectBtn" onclick="connectWallet()">🦊 Connect MetaMask</button>
		<button onclick="window.close()">Cancel</button>
		
		<div style="margin-top: 30px; font-size: 14px; color: #888;">
			<p>Make sure you have MetaMask installed and are on Base network</p>
		</div>
	</div>

	<script>
		async function connectWallet() {
			const statusDiv = document.getElementById('status');
			const statusText = document.getElementById('statusText');
			const connectBtn = document.getElementById('connectBtn');
			
			statusDiv.style.display = 'block';
			statusDiv.className = 'status loading';
			statusText.textContent = 'Connecting to MetaMask...';
			connectBtn.disabled = true;
			
			try {
				// Wait for MetaMask to load
				await new Promise(resolve => setTimeout(resolve, 1000));
				
				// Check if MetaMask is installed
				if (typeof window.ethereum === 'undefined') {
					throw new Error('MetaMask not found. Please install MetaMask extension.');
				}
				
				// Request account access
				const accounts = await window.ethereum.request({
					method: 'eth_requestAccounts'
				});
				
				if (accounts.length === 0) {
					throw new Error('No accounts found. Please unlock MetaMask.');
				}
				
				const address = accounts[0];
				
				// Switch to Base network
				try {
					await window.ethereum.request({
						method: 'wallet_switchEthereumChain',
						params: [{ chainId: '0x2105' }], // Base mainnet
					});
				} catch (switchError) {
					// Add Base network if not exists
					if (switchError.code === 4902) {
						await window.ethereum.request({
							method: 'wallet_addEthereumChain',
							params: [{
								chainId: '0x2105',
								chainName: 'Base',
								nativeCurrency: { name: 'ETH', symbol: 'ETH', decimals: 18 },
								rpcUrls: ['https://mainnet.base.org'],
								blockExplorerUrls: ['https://basescan.org']
							}]
						});
					}
				}
				
				// Success - redirect back to game
				statusDiv.className = 'status success';
				statusText.textContent = 'Connected! Redirecting back to game...';
				
				setTimeout(() => {
					window.location.href = 'http://localhost:' + window.location.port + '/callback?address=' + address + '&session=" + auth_session_id + "';
				}, 1500);
				
			} catch (error) {
				console.error('Connection failed:', error);
				statusDiv.className = 'status error';
				statusText.textContent = 'Error: ' + error.message;
				connectBtn.disabled = false;
			}
		}
		
		// Check MetaMask availability on load
		window.addEventListener('load', async () => {
			// Wait for extensions to load
			setTimeout(async () => {
				if (typeof window.ethereum !== 'undefined') {
					try {
						const accounts = await window.ethereum.request({ method: 'eth_accounts' });
						if (accounts.length > 0) {
							document.getElementById('statusText').textContent = '✅ MetaMask connected. Click to continue.';
						} else {
							document.getElementById('statusText').textContent = '🦊 MetaMask detected. Click to connect.';
						}
					} catch (error) {
						console.log('Could not check existing connection');
						document.getElementById('statusText').textContent = '🦊 MetaMask ready. Click to connect.';
					}
				} else {
					document.getElementById('statusText').textContent = '❌ MetaMask not found. Please install MetaMask.';
				}
			}, 1000);
		});
	</script>
</body>
</html>"""

# Stop callback server
func _stop_callback_server() -> void:
	if http_server:
		http_server.stop()
		http_server = null
	print("[BrowserOAuth] Callback server stopped")

# Handle successful wallet connection
func _on_wallet_connected(address: String) -> void:
	connected_address = address
	print("[BrowserOAuth] ✅ Wallet connected: ", address)
	wallet_connected.emit(address)
	
	# Stop the server after successful connection
	_stop_callback_server()

# Disconnect wallet
func disconnect_wallet() -> void:
	connected_address = ""
	_stop_callback_server()
	wallet_disconnected.emit()

# Check if connected
func is_wallet_connected() -> bool:
	return connected_address != ""

# Get connected address
func get_address() -> String:
	return connected_address
