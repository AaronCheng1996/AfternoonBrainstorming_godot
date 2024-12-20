extends ColorRect
class_name GroupButton

signal group_selected(group: GroupButton)

@onready var lbl_piece_group: RichTextLabel = $lbl_piece_group

var group : Array = Global.card_groups.white
var font_size : int = 20
var label_font_color : Color

func set_text(text: String):
	lbl_piece_group.text = Global.set_font_center(Global.set_font_color(Global.set_font_size(text, font_size), label_font_color))

func selected():
	color = Color("#303030")

func unselected():
	color = Color("#383838")

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("group_selected", self)
