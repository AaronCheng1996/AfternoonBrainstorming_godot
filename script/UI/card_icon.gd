extends Control
class_name CardIcon

signal remove(icon: CardIcon)

@onready var icon: Sprite2D = $icon
@onready var select_effect: ColorRect = $select_effect
var player_num : int = 0
var index : int = 0
var show_name : String = ""

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("remove", self)

func _on_mouse_entered() -> void:
	select_effect.show()

func _on_mouse_exited() -> void:
	select_effect.hide()
