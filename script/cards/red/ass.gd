extends Piece
class_name RedAss

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 2
var buff_value_sum : int = 0
	
func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.ass
	description = Global.data.card.red.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func attack() -> void:
	buff_value_sum = 0
	super.attack()
	#最後一次加
	if not has_node("BuffComponent"):
		return
	#給友方
	var attack_buff = red.create_attack_buff(buff_value_sum, card_owner)
	var allys = attack_component.find_nearest_target(location, Global.board_pieces.filter(filter_ally_piece))
	allys = allys.filter(func(element: Piece): return !element.is_dead)
	if allys.size() > 0:
		var random_index = Global.rng.randi_range(0, allys.size() - 1)
		allys[random_index].add_buff(attack_buff)

func _on_attack_component_on_kill(target: Piece) -> void:
	buff_value_sum += buff_value
