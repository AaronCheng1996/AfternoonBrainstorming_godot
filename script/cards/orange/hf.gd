extends Piece
class_name OrangeHF

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.hf
	description = Global.data.card.orange.hf.format([str(buff_value)])

func attack() -> void:
	super.attack()
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())

func after_move() -> void:
	Global.piece_moved(self)
	var attack_buff = AttackBuff.new()
	attack_buff.show_name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description.format([str(buff_value)])
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag])
	attack_buff.value = buff_value
	attack_buff.duration = 1
	add_buff(attack_buff)
