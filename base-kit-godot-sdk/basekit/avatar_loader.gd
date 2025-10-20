class_name AvatarLoader
extends Node

signal avatar_loaded(texture: Texture2D)
signal avatar_failed(error: String)

var http_request: HTTPRequest

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)

# Load avatar from URL
func load_avatar(url: String) -> void:
	print("[AvatarLoader] Loading avatar from: ", url)
	
	if url == "":
		avatar_failed.emit("Empty URL")
		return
	
	var error = http_request.request(url)
	if error != OK:
		avatar_failed.emit("Failed to make request: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("[AvatarLoader] Response code: ", response_code)
	
	if response_code != 200:
		avatar_failed.emit("HTTP Error: " + str(response_code))
		return
	
	# Try to create texture from image data
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	
	if error != OK:
		# Try JPG if PNG fails
		error = image.load_jpg_from_buffer(body)
	
	if error != OK:
		# Try SVG or other formats - for now just fail
		avatar_failed.emit("Failed to load image format")
		return
	
	# Create texture from image
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	
	print("[AvatarLoader] ✅ Avatar loaded successfully!")
	avatar_loaded.emit(texture)