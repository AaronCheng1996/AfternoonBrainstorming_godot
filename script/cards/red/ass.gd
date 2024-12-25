extends Piece
class_name RedAss

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 2
	
func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.ass
	description = Global.data.card.red.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

#斬殺為最近友軍加攻
func _on_attack_component_on_kill(target: Piece) -> void:
	var ally = get_nearest_ally()
	if ally != null:
		red.attack_buff(buff_value, ally)
