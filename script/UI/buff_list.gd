extends Control
class_name BuffIconList

@onready var buff_icon_list: GridContainer = $buff_list
@export var columns : int = 6

var buff_font_size : int = 10

func _ready() -> void:
	buff_icon_list.columns = columns

func show_buffs(buff_list: Array) -> void:
	for child in buff_icon_list.get_children():
		buff_icon_list.remove_child(child)
	for buff: Buff in buff_list:
		if not buff.icon_path.has("default"):
			continue
		var icon = TextureRect.new()
		icon.texture = load(buff.icon_path.default)
		buff_icon_list.add_child(icon)
		if buff.show_value:
			var lbl_value = Label.new()
			lbl_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			lbl_value.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			lbl_value.size = icon.size
			lbl_value.text = str(buff.value)
			lbl_value.set("theme_override_font_sizes/font_size", buff_font_size)
			icon.add_child(lbl_value)

func show_mini_buffs(buff_list: Array) -> void:
	for child in buff_icon_list.get_children():
		buff_icon_list.remove_child(child)
	for buff: Buff in buff_list:
		if not buff.icon_path.has("mini"):
			continue
		var icon = TextureRect.new()
		icon.texture = load(buff.icon_path.mini)
		buff_icon_list.add_child(icon)
