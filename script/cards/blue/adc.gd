extends Piece
class_name BlueADC

var blue = preload("res://script/cards/blue/blue.gd").new()

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.blue.adc.show_name
	description = Global.data.card.blue.adc.description.format([str(buff_value)])	
	hint = Global.data.card.blue.adc.hint
	piece_type = Global.PieceType.ADC

func trigger_effect(value: int) -> void:
	if is_on_board:
		auto_attack()

func _on_attack_component_on_kill(target: Piece) -> void:
	blue.add_blue_charge(card_owner, buff_value)
