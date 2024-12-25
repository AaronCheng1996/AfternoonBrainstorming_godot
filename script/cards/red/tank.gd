extends Piece
class_name RedTank

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.tank
	description = Global.data.card.red.tank.format([str(buff_value)])

#承受傷害，給予隊友 2 盾
func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	#最接近的友方
	var ally = get_nearest_ally()
	if ally != null:
		red.shield_buff(buff_value, ally)
	return super.take_damaged(damage, applyer)
