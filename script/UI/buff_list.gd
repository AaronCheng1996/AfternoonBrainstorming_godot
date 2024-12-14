extends Control
class_name BuffIconList

@onready var buff_icon_list: GridContainer = $buff_list
@export var columns : int = 6

func _ready() -> void:
	buff_icon_list.columns = columns

func show_buffs(buff_list: Array) -> void:
	for child in buff_icon_list.get_children():
		buff_icon_list.remove_child(child)
	for buff in buff_list:
		if not buff.icon_path.has("default"):
			continue
		var icon = TextureRect.new()
		icon.texture = load(buff.icon_path.default)
		buff_icon_list.add_child(icon)

func show_mini_buffs(buff_list: Array) -> void:
	print(buff_list)
	for child in buff_icon_list.get_children():
		buff_icon_list.remove_child(child)
	for buff in buff_list:
		if not buff.icon_path.has("mini"):
			continue
		var icon = TextureRect.new()
		icon.texture = load(buff.icon_path.mini)
		buff_icon_list.add_child(icon)
