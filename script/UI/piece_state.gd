extends Node2D
class_name PieceState

@onready var icon = $icon
@onready var txt_value = $txt_value
@export var icon_texture : CompressedTexture2D
var value : int = 0
var default_value : int = 0

func _ready() -> void:
	if icon_texture:
		icon.texture = icon_texture

func refresh_value_text() -> void:
	if txt_value:
		var text = str(value)
		if value > default_value:
			text = set_font_color(text, "green")
		elif value < default_value:
			text = set_font_color(text, "red")
		txt_value.text = set_font_center(set_font_size(text, "20"))

#置中文字
func set_font_center(text: String) -> String:
	return "[center]{0}[/center]".format([text])

func set_font_size(text: String, size: String) -> String:
	return "[font_size={0}]{1}[/font_size]".format([size, text])

func set_font_color(text: String, color: String) -> String:
	return "[color={0}]{1}[/color]".format([color, text])
