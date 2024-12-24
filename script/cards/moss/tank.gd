extends Piece
class_name MossTank

var moss = preload("res://script/cards/moss/moss.gd").new()

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.tank
	description = Global.data.card.moss.tank.format([str(buff_value)])

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	var result = super.take_damaged(damage, applyer)
	moss.add_rune(card_owner, buff_value)
	return result
