extends Node
class_name Red

#取得紅鑽石
func get_red_sp(pieces: Array) -> Array:
	var result := []
	for piece: Piece in pieces:
		if piece.show_name == Global.data.card.red.name + Global.data.card.default_name.sp:
			result.append(piece)
	return result

func create_attack_buff(value: int) -> AttackBuff:
	var attack_buff = AttackBuff.new()
	attack_buff.show_name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	attack_buff.icon_path = Global.buff_icon.attack_buff
	attack_buff.value = value
	return attack_buff

func create_health_buff(value: int) -> HealthBuff:
	var health_buff = HealthBuff.new()
	health_buff.show_name = Global.data.buff.health_buff.name
	health_buff.description = Global.data.buff.health_buff.description
	health_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	health_buff.icon_path = Global.buff_icon.health_buff
	health_buff.value = value
	return health_buff
