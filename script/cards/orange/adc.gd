extends Piece
class_name OrangeADC

func _init() -> void:
	show_name = Global.data.card.orange.adc.show_name
	description = Global.data.card.orange.adc.description
	hint = Global.data.card.orange.adc.hint
	piece_type = Global.PieceType.ADC

func attack() -> void:
	super.attack()
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())

func after_move() -> void:
	auto_attack()
	super.after_move()
