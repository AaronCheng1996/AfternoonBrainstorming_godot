extends Node
class_name Red

var attack_sum = [0, 0]
var health_sum = [0, 0]
var shield_sum = [0, 0]

#取得紅鑽石
func get_redsp(player: Player) -> Array:
	var result := []
	for piece in Global.board_dic.values():
		if piece is int:
			continue
		if piece.show_name == Global.data.card.red.name + Global.data.card.default_name.sp and piece.card_owner.id == player.id:
			result.append(piece)
	return result

func buff_redsp(buff: Buff, player: Player) -> void:
	for piece: Piece in get_redsp(player):
		piece.add_buff(buff)

func create_attack_buff(value: int, player: Player) -> AttackBuff:
	var attack_buff = AttackBuff.new()
	attack_buff.show_name = Global.data.buff.attack_buff.name
	attack_buff.description = Global.data.buff.attack_buff.description.format([str(value)])
	attack_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	attack_buff.icon_path = Global.buff_icon.attack_buff
	attack_buff.value = value
	buff_redsp(attack_buff, player)
	attack_sum[player.id] += value
	return attack_buff

func create_health_buff(value: int, player: Player) -> HealthBuff:
	var health_buff = HealthBuff.new()
	health_buff.show_name = Global.data.buff.health_buff.name
	health_buff.description = Global.data.buff.health_buff.description.format([str(value)])
	health_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.RED])
	health_buff.icon_path = Global.buff_icon.health_buff
	health_buff.value = value
	buff_redsp(health_buff, player)
	health_sum[player.id] += value
	return health_buff

func add_shield_sum(value: int, player: Player) -> void:
	shield_sum[player.id] += value
