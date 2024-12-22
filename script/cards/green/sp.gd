extends Piece
class_name GreenSP

var green = preload("res://script/cards/green/green.gd").new()
var buff_value = 10

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.sp
	description = Global.data.card.green.sp.format([str(buff_value)])

func on_piece_set() -> void:
	super.on_piece_set()
	green.add_luck_buff(card_owner, buff_value)
	var repeat = (green.check_luck(card_owner) - 50) / 10
	if repeat <= 0:
		return
	for i in repeat:
		green.create_lucky_box(Global.get_random_empty_slot())
