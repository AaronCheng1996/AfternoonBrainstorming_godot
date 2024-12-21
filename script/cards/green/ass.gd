extends Piece
class_name GreenAss

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 5
	
func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.ass
	description = Global.data.card.green.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	green.add_luck_buff(target, -buff_value)
	green.add_luck_buff(self, buff_value)
