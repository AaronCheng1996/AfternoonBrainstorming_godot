extends Piece
class_name GreenHF

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 5
var kill_count : int = 0

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.hf
	description = Global.data.card.green.hf.format([str(buff_value)])

func attack() -> void:
	kill_count = 0
	super.attack()
	for i in kill_count:
		green.add_luck_buff(card_owner, buff_value)
		green.create_lucky_box(Global.get_random_empty_slot())

func _on_attack_component_on_kill(target: Piece) -> void:
	if target.show_name == Global.data.card.token.token_name.lucky_box:
		kill_count += 1
