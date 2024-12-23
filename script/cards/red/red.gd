extends Node
class_name Red

#取得紅鑽石
func get_redsp(player: Player) -> Array:
	var result := []
	for piece in Global.board_pieces:
		if piece.show_name == Global.data.card.red.name + Global.data.card.default_name.sp and piece.card_owner.id == player.id:
			result.append(piece)
	return result

func buff_redsp(buff: Buff, player: Player) -> void:
	for piece: Piece in get_redsp(player):
		player.buff_history.append(buff)
		piece.add_buff(buff)

func create_attack_buff(value: int, player: Player) -> AttackBuff:
	var attack_buff = AttackBuff.new()
	attack_buff.show_name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description.format([str(value)])
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	attack_buff.value = value
	buff_redsp(attack_buff, player)
	player.buff_history.append(attack_buff)
	return attack_buff

func create_health_buff(value: int, player: Player) -> HealthBuff:
	var health_buff = HealthBuff.new()
	health_buff.show_name = Global.data.buff.health_buff.name
	health_buff.description = Global.data.buff.health_buff.description.format([str(value)])
	health_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	health_buff.value = value
	buff_redsp(health_buff, player)
	player.buff_history.append(health_buff)
	return health_buff

func create_shield_buff(value: int, player: Player) -> Shielded:
	var shield_buff = Shielded.new()
	shield_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	shield_buff.duration = 1
	shield_buff.value = value
	buff_redsp(shield_buff, player)
	player.buff_history.append(shield_buff)
	return shield_buff
