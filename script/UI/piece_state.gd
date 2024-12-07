extends Node2D
class_name PieceState

@onready var icon = $icon
@onready var txt_value = $txt_value
@onready var txt_icon = $txt_value/txt_icon
@export var icon_mode : bool = false
@export var icon_texture : CompressedTexture2D
@export var txt_icon_texture : CompressedTexture2D
var value : int = 0
var default_value : int = 0

func _ready() -> void:
	if icon_texture:
		icon.texture = icon_texture

func refresh_value_text() -> void:
	if not icon_mode:
		if txt_value:
			var text = str(value)
			text = Global.set_font_color(text, Global.get_font_color(value, default_value))
			txt_value.text = Global.set_font_center(Global.set_font_size(text, "20"))
	else:
		if txt_icon_texture:
			txt_icon.texture = txt_icon_texture