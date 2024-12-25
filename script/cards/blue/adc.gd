extends Piece
class_name BlueADC

var blue = preload("res://script/cards/blue/blue.gd").new()

var buff_value : int = 2
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.adc
	description = Global.data.card.blue.adc.format([str(buff_value)])

func attack() -> void:
	buff_value_sum = 0
	super.attack()
	blue.add_blue_charge(card_owner, buff_value_sum)

func trigger_effect(value: int) -> void:
	if is_on_board:
		auto_attack()

func _on_attack_component_on_kill(target: Piece) -> void:
	buff_value_sum += buff_value
