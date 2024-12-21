extends Piece
class_name RedAPT

var red = preload("res://script/cards/red/red.gd").new()
var buff_target := [self]
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.apt
	description = Global.data.card.red.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack() -> void:
	if has_node("AttackComponent"):
		super.attack()
		buff_target = [self]
		#生成buff
		var attack_buff = red.create_attack_buff(buff_value, card_owner)
		var health_buff = red.create_health_buff(buff_value, card_owner)
		#多生成一次給紅鑽
		attack_buff = red.create_attack_buff(buff_value, card_owner)
		health_buff = red.create_health_buff(buff_value, card_owner)
		#給友方
		var allys = attack_component.find_nearest_target(location, Global.board_pieces.filter(filter_ally_piece))
		allys = allys.filter(func(element: Piece): return !element.is_dead)
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			allys[random_index].add_buff(attack_buff)
			allys[random_index].add_buff(health_buff)
		#給自己
		add_buff(attack_buff)
		add_buff(health_buff)
