extends Piece
class_name BlueLF

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.blue.lf.show_name
	description = Global.data.card.blue.lf.description
	hint = Global.data.card.blue.lf.hint
	piece_type = Global.PieceType.LF

func _on_attack_component_on_hit(target: Piece) -> void:
	blue.add_blue_charge(card_owner, buff_value)
