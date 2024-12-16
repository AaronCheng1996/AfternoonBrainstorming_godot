extends Piece
class_name RedAP

var buff_value : int = 100

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.ap
	description = Global.data.piece.red.ap.format([str(buff_value)])

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.attack_component:
		return
	if not buff_component:
		return
	if target.attack_component.atk == 0:
		return
	var attack_debuff = AttackBuff.new()
	attack_debuff.name = Global.data.buff.attack_stolen.name
	attack_debuff.description = Global.data.buff.attack_stolen.description
	attack_debuff.tag.append_array([Global.BuffTag.DEBUFF])
	attack_debuff.icon_path = Global.buff_icon.attack_debuff
	attack_debuff.value = -target.attack_component.atk * buff_value / 100.0
	target.buff_component.add_buff(attack_debuff)
	
	var attack_buff = AttackBuff.new()
	attack_buff.name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	attack_buff.icon_path = Global.buff_icon.attack_buff
	attack_buff.value = -attack_debuff.value
	buff_component.add_buff(attack_buff)
