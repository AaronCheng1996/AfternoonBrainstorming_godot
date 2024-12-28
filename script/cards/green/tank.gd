extends Piece
class_name GreenTank

var green = preload("res://script/cards/green/green.gd").new()

func _init() -> void:
	show_name = Global.data.card.green.tank.show_name
	description = Global.data.card.green.tank.description
	hint = Global.data.card.green.tank.hint
	piece_type = Global.PieceType.TANK

#承受傷害，給傷害者不幸事件
func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	if applyer != null:
		green.unlucky_event(applyer)
	return super.take_damaged(damage, applyer)
