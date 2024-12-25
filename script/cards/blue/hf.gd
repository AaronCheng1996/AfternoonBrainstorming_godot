extends Piece
class_name BlueHF

var blue = preload("res://script/cards/blue/blue.gd").new()

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.hf
	var text = str(blue.get_blue_charge_count(card_owner))
	Global.set_font_color(text, Global.get_font_color(blue.get_blue_charge_count(card_owner), 0))
	description = Global.data.card.blue.hf.format([str(blue.get_blue_charge_count(card_owner))])

func refresh() -> void:
	var text = str(blue.get_blue_charge_count(card_owner))
	Global.set_font_color(text, Global.get_font_color(blue.get_blue_charge_count(card_owner), 0))
	description = Global.data.card.blue.hf.format([text])
	super.refresh()

func attack() -> void:
	if has_node("AttackComponent"):
		var value = blue.get_blue_charge_count(card_owner)
		attack_component.atk += value
		attack_component.attack(Global.board_pieces.filter(filter_opponent_piece))
		attack_component.atk -= value

func trigger_effect(value: int) -> void:
	refresh()
