extends Piece
class_name GreenADC

var green = preload("res://script/cards/green/green.gd").new()

func _init() -> void:
	show_name = Global.data.card.green.adc.show_name
	description = Global.data.card.green.adc.description
	hint = Global.data.card.green.adc.hint
	piece_type = Global.PieceType.ADC

#在攻擊範圍生成幸運箱
func attack() -> void:
	super.attack()
	for location in get_target_location():
		if green.luck_is_trigger(card_owner):
			green.create_lucky_box(location)
