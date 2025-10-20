extends Control

@onready var test_button = $VBoxContainer/TestButton
@onready var result_label = $VBoxContainer/ResultLabel
@onready var log_text = $VBoxContainer/LogText

var wallet_connector: WalletConnector

func _ready():
	test_button.pressed.connect(_on_test_button_pressed)
	
	# Create wallet connector for testing
	wallet_connector = WalletConnector.new()
	add_child(wallet_connector)
	
	# Connect signals
	wallet_connector.connection_success.connect(_on_connection_success)
	wallet_connector.connection_failed.connect(_on_connection_failed)
	
	result_label.text = "Ready to test Base RPC connection"

func _on_test_button_pressed():
	result_label.text = "Testing Base RPC..."
	log_text.text = ""
	test_button.disabled = true
	
	# Test the RPC connection
	wallet_connector.test_connection()

func _on_connection_success(address: String):
	result_label.text = "✅ RPC Connection Successful!"
	log_text.text += "Connected address: " + address + "\n"
	test_button.disabled = false

func _on_connection_failed(error: String):
	result_label.text = "❌ RPC Connection Failed"
	log_text.text += "Error: " + error + "\n"
	test_button.disabled = false