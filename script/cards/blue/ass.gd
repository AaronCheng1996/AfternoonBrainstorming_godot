extends Piece
class_name BlueAss

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 2
	
func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.ass
	description = Global.data.card.blue.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	blue.add_blue_charge(card_owner, buff_value)
