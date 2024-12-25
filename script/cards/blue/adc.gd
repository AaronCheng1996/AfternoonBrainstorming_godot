extends Piece
class_name BlueADC

var blue = preload("res://script/cards/blue/blue.gd").new()

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.adc
	description = Global.data.card.blue.adc.format([str(buff_value)])	

func trigger_effect(value: int) -> void:
	if is_on_board:
		auto_attack()

func _on_attack_component_on_kill(target: Piece) -> void:
	blue.add_blue_charge(card_owner, buff_value)
