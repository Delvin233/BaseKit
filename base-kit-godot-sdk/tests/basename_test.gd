extends Control

@onready var address_input = $VBoxContainer/AddressInput
@onready var resolve_button = $VBoxContainer/ResolveButton
@onready var result_label = $VBoxContainer/ResultLabel
@onready var avatar_display = $VBoxContainer/AvatarDisplay

var basename_resolver: BaseNameResolver
var avatar_loader: AvatarLoader

func _ready():
	resolve_button.pressed.connect(_on_resolve_button_pressed)
	
	# Create resolver
	basename_resolver = BaseNameResolver.new()
	add_child(basename_resolver)
	
	# Create avatar loader
	avatar_loader = AvatarLoader.new()
	add_child(avatar_loader)
	
	# Connect signals
	basename_resolver.name_resolved.connect(_on_name_resolved)
	basename_resolver.avatar_resolved.connect(_on_avatar_resolved)
	avatar_loader.avatar_loaded.connect(_on_avatar_loaded)
	avatar_loader.avatar_failed.connect(_on_avatar_failed)
	
	# Set test address
	address_input.text = "0x742d35Cc6634C0532925a3b8D404d3aABb8cf7c3"

func _on_resolve_button_pressed():
	var address = address_input.text.strip_edges()
	if address == "":
		result_label.text = "Please enter an address"
		return
	
	result_label.text = "Resolving..."
	resolve_button.disabled = true
	avatar_display.texture = null
	
	basename_resolver.resolve_base_name(address)

func _on_name_resolved(address: String, name: String):
	result_label.text = "✅ Resolved: " + name
	resolve_button.disabled = false
	
	# Try to load avatar if it's a Base Name
	if name.ends_with(".base.eth"):
		basename_resolver.resolve_avatar(name)

func _on_avatar_resolved(name: String, avatar_url: String):
	print("Avatar URL: ", avatar_url)
	avatar_loader.load_avatar(avatar_url)

func _on_avatar_loaded(texture: Texture2D):
	avatar_display.texture = texture
	print("✅ Avatar loaded and displayed!")

func _on_avatar_failed(error: String):
	print("❌ Avatar failed: ", error)