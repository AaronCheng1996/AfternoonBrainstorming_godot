extends Piece
class_name GreenHF

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 5

func _init() -> void:
	show_name = Global.data.card.green.hf.show_name
	description = Global.data.card.green.hf.description.format([str(buff_value)])
	hint = Global.data.card.green.hf.hint
	piece_type = Global.PieceType.HF

func _on_attack_component_on_kill(target: Piece) -> void:
	if target.show_name == Global.data.card.spell_and_token.lucky_box.show_name:
		green.add_luck_buff(card_owner, buff_value)
		green.create_lucky_box(Global.get_random_empty_slot())
