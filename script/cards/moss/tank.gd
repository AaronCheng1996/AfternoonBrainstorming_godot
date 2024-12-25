extends Piece
class_name MossTank

var moss = preload("res://script/cards/moss/moss.gd").new()

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.tank
	description = Global.data.card.moss.tank.format([str(buff_value)])

func refresh() -> void:
	#更改圖示
	moss.update_icon(self)

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	moss.add_rune(card_owner, buff_value)
	return super.take_damaged(damage, applyer)
