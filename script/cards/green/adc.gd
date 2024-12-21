extends Piece
class_name GreenADC

var green = preload("res://script/cards/green/green.gd").new()

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.adc
	description = Global.data.card.green.adc

func attack() -> void:
	super.attack()
	for location in get_target_location():
		if green.luck_is_trigger(card_owner):
			green.create_lucky_box(location)
