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
	var result = super.take_damaged(damage, applyer)
	#最接近的友方
	var allys = attack_component.find_nearest_target(location, card_owner.on_board.filter(filter_ally_piece))
	allys = allys.filter(func(element: Piece): return !element.is_dead)
	if allys.size() > 0:
		var random_index = Global.rng.randi_range(0, allys.size() - 1)
		allys[random_index].shielded(buff_value, self)
	
	#給紅鑽
	for piece: Piece in red.get_redsp(card_owner):
		piece.shielded(buff_value, self)
	return result
