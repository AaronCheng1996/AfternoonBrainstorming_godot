extends Piece
class_name OrangeTank

var value : int = 1

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.tank
	description = Global.data.card.orange.tank.format([value])

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	Global.get_move_spell(card_owner)
	return super.take_damaged(damage, applyer)
