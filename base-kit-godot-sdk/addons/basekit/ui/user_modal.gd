@tool
class_name UserModal
extends Control

signal copy_name_requested()
signal disconnect_requested()

@onready var modal_bg = $ModalBG
@onready var modal_panel = $ModalBG/ModalPanel
@onready var copy_button = $ModalBG/ModalPanel/ButtonsHBox/CopyButton
@onready var disconnect_button = $ModalBG/ModalPanel/ButtonsHBox/DisconnectButton

func _ready():
	if not Engine.is_editor_hint():
		# Connect signals only if nodes exist
		if copy_button:
			copy_button.pressed.connect(_on_copy_pressed)
		if disconnect_button:
			disconnect_button.pressed.connect(_on_disconnect_pressed)
		if modal_bg:
			modal_bg.gui_input.connect(_on_modal_bg_input)
	
	visible = false

func show_modal(base_name: String, address: String):
	# Simple modal - just show the buttons
	visible = true
	
	# Animate in
	if modal_panel:
		modal_panel.scale = Vector2(0.8, 0.8)
		modal_panel.modulate.a = 0.0
		
		var tween = create_tween()
		tween.parallel().tween_property(modal_panel, "scale", Vector2.ONE, 0.2)
		tween.parallel().tween_property(modal_panel, "modulate:a", 1.0, 0.2)

func hide_modal():
	if modal_panel:
		var tween = create_tween()
		tween.parallel().tween_property(modal_panel, "scale", Vector2(0.8, 0.8), 0.15)
		tween.parallel().tween_property(modal_panel, "modulate:a", 0.0, 0.15)
		tween.tween_callback(func(): visible = false)
	else:
		visible = false

func _on_copy_pressed():
	copy_name_requested.emit()
	hide_modal()

func _on_disconnect_pressed():
	disconnect_requested.emit()
	hide_modal()

func _on_modal_bg_input(event):
	if event is InputEventMouseButton and event.pressed:
		hide_modal()
