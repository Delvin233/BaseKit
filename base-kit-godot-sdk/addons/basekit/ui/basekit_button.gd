@tool
class_name BaseKitButton
extends Button

## Simple BaseKit wallet connection button
## Drop this anywhere in your game for instant Web3 identity!

signal wallet_connected(address: String, base_name: String)
signal wallet_disconnected()

@export var button_style: ButtonStyle = ButtonStyle.CONNECT_WALLET
@export var show_base_name: bool = true
@export var auto_resize: bool = true

enum ButtonStyle {
	CONNECT_WALLET,
	SIGN_IN_BASE,
	WEB3_LOGIN,
	CUSTOM
}

var is_connected: bool = false
var user_modal: UserModal

func _ready():
	# Connect to BaseKit signals
	if not Engine.is_editor_hint():
		BaseKit.wallet_connected.connect(_on_wallet_connected)
		BaseKit.wallet_disconnected.connect(_on_wallet_disconnected)
		BaseKit.basename_resolved.connect(_on_basename_resolved)
		
		# Create user modal
		user_modal = preload("res://addons/basekit/ui/user_modal.tscn").instantiate()
		get_tree().root.add_child.call_deferred(user_modal)
		user_modal.copy_name_requested.connect(_on_copy_name)
		user_modal.disconnect_requested.connect(_on_disconnect_user)
	
	# Connect button press
	pressed.connect(_on_button_pressed)
	
	# Set initial appearance
	_update_button_appearance()

func _on_button_pressed():
	if Engine.is_editor_hint():
		return
		
	if BaseKit.is_wallet_connected():
		# Show user modal instead of disconnecting immediately
		var base_name = BaseKit.get_base_name()
		var address = BaseKit.get_connected_address()
		user_modal.show_modal(base_name, address)
	else:
		BaseKit.connect_wallet()

func _on_wallet_connected(address: String):
	is_connected = true
	_update_button_appearance()
	wallet_connected.emit(address, BaseKit.get_base_name())

func _on_wallet_disconnected():
	is_connected = false
	_update_button_appearance()
	wallet_disconnected.emit()

func _on_basename_resolved(address: String, name: String):
	if is_connected and show_base_name:
		_update_button_appearance()

func _update_button_appearance():
	if Engine.is_editor_hint():
		text = "🦕 BaseKit Button"
		return
	
	if is_connected:
		if show_base_name:
			var base_name = BaseKit.get_base_name()
			text = "👋 " + base_name
		else:
			text = "✅ Connected"
	else:
		match button_style:
			ButtonStyle.CONNECT_WALLET:
				text = "🔗 Connect Wallet"
			ButtonStyle.SIGN_IN_BASE:
				text = "🦕 Sign in with Base"
			ButtonStyle.WEB3_LOGIN:
				text = "🌐 Web3 Login"
			ButtonStyle.CUSTOM:
				if text == "":
					text = "Connect"
	
	if auto_resize:
		custom_minimum_size.x = 0  # Let it auto-size

func _on_copy_name():
	var base_name = BaseKit.get_base_name()
	DisplayServer.clipboard_set(base_name)
	print("📋 Copied to clipboard: ", base_name)

func _on_disconnect_user():
	BaseKit.disconnect_wallet()
