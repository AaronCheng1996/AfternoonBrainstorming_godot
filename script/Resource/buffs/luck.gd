extends Buff
class_name Luck

func add_value(target, add: int) -> void:
	value += add
	if value < 1: #下限 1
		value = 1
	if value > 200: #上限 200
		value = 200
	if value < 45: #切換圖示
		icon_path = Global.buff_icon.bad_luck
	else:
		icon_path = Global.buff_icon.luck
