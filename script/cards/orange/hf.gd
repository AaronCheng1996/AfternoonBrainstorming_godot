extends Piece
class_name OrangeHF

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.orange.hf.show_name
	description = Global.data.card.orange.hf.description.format([str(buff_value)])
	hint = Global.data.card.orange.hf.hint
	piece_type = Global.PieceType.HF

func attack() -> void:
	super.attack()
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())

func after_move() -> void:
	Global.piece_moved(self)
	var attack_buff = buff_component.get_buff(Global.data.buff.attack_buff_temp.name)
	if attack_buff == null:
		attack_buff = AttackBuff.new()
		attack_buff.show_name = Global.data.buff.attack_buff_temp.name
		attack_buff.description = Global.data.buff.attack_buff_temp.description.format([str(buff_value)])
		attack_buff.tag.append_array([Global.BuffTag.BUFF])
		attack_buff.value = buff_value
		attack_buff.duration = 1
		add_buff(attack_buff)
	else:
		attack_buff.add_value(self, 1)
