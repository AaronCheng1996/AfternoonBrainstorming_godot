extends Piece
class_name GreenHF

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 5

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.hf
	description = Global.data.card.green.hf.format([str(buff_value)])

func _on_attack_component_on_kill(target: Piece) -> void:
	if target.show_name == Global.data.card.token.token_name.lucky_box:
		green.add_luck_buff(card_owner, buff_value)
		green.create_lucky_box(Global.get_random_empty_slot())
