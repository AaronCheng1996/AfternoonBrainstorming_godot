extends Piece
class_name BlueTank

var blue = preload("res://script/cards/blue/blue.gd").new()

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.blue.tank.show_name
	description = Global.data.card.blue.tank.description
	hint = Global.data.card.blue.tank.hint
	piece_type = Global.PieceType.TANK

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	blue.add_blue_charge(card_owner, buff_value)
	return super.take_damaged(damage, applyer)
