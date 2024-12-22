extends Piece
class_name BlueTank

var blue = preload("res://script/cards/blue/blue.gd").new()

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.tank
	description = Global.data.card.blue.tank

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	var result = super.take_damaged(damage, applyer)
	blue.add_blue_charge(card_owner, buff_value)
	return result
