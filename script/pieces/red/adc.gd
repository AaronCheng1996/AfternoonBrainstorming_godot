extends Piece
class_name RedADC

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.adc
	description = Global.data.piece.red.adc.format([str(buff_value)])

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	if not buff_component:
		return
	var attack_buff = AttackBuff.new()
	attack_buff.name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	attack_buff.icon_path = Global.buff_icon.attack_buff
	attack_buff.value = buff_value
	buff_component.add_buff(attack_buff)
