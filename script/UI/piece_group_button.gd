extends ColorRect
class_name PieceGroupButton

@onready var txt_piece_group: RichTextLabel = $txt_piece_group

var group : String = "white"

func selected():
	self.color = Color(30, 30, 30)

func unselected():
	self.color = Color(34, 34, 34)

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("group_selected", group)
