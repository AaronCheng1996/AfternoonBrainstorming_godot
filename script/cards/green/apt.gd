extends Piece
class_name GreenAPT

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.apt
	description = Global.data.card.green.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack() -> void:
	if has_node("AttackComponent"):
		#生成箱子
		var directions = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
		for i: Vector2i in directions:
			green.create_lucky_box(location + i)
		#執行攻擊
		super.attack()
