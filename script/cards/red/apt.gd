extends Piece
class_name RedAPT

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.apt
	description = Global.data.card.red.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack() -> void:
	if has_node("AttackComponent"):
		super.attack()
		#buff
		red.attack_buff(buff_value, self)
		red.health_buff(buff_value, self)
		#給友方
		var allys = attack_component.find_nearest_target(location, Global.board_pieces.filter(filter_ally_piece))
		allys = allys.filter(func(element: Piece): return !element.is_dead)
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			red.attack_buff(buff_value, allys[random_index])
			red.health_buff(buff_value, allys[random_index])
