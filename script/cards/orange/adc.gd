extends Piece
class_name OrangeADC

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.adc
	description = Global.data.card.orange.adc

func attack() -> void:
	super.attack()
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())

func after_move() -> void:
	Global.piece_moved(self)
	auto_attack()
