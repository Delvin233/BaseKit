extends Control

func _ready():
	print("✅ Minimal test started")
	print("✅ BaseKit available: ", BaseKit != null)
	
	# Test BaseKit button
	var button = preload("res://addons/basekit/ui/basekit_button.tscn").instantiate()
	add_child(button)
	button.position = Vector2(100, 100)
	
	print("✅ BaseKit button created successfully")
