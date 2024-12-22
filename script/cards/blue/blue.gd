extends Node
class_name Blue

var discharge_count = 3

#獲得藍球
func add_blue_charge(player: Player, value: int = 1) -> void:
	if player == null:
		return
	if not player.has_node("BuffComponent"):
		return
	if value == 0:
		return
	if not player.buff_component.has_buff(Global.data.buff.blue_charge.name):
		player.buff_component.add_buff(get_blue_charge_buff())
	var blue_charge_buff = player.buff_component.get_buff(Global.data.buff.blue_charge.name)
	blue_charge_buff.value += value
	print("藍球+" + str(value))
	while blue_charge_buff.value >= discharge_count:
		print("藍球：release")
		blue_charge_release(player, blue_charge_buff)
		blue_charge_buff.value -= discharge_count
	print("藍球：" + str(blue_charge_buff.value))
	player.buff_component.show_buff()
	#更新hf數值
	for piece in Global.get_all_pieces(player):
		if piece.show_name == Global.data.card.blue.name + Global.data.card.default_name.hf:
			piece.attack_component.atk += value
			piece.refresh()

#取得藍球數
func get_blue_charge_count(player: Player) -> int:
	if player == null:
		return 0
	if not player.has_node("BuffComponent"):
		return 0
	if not player.buff_component.has_buff(Global.data.buff.blue_charge.name):
		player.buff_component.add_buff(get_blue_charge_buff())
	return player.buff_component.get_buff(Global.data.buff.blue_charge.name).value

#取得藍球buff
func get_blue_charge_buff() -> Buff:
	var blue_charge_buff: BlueCharge = BlueCharge.new()
	blue_charge_buff.show_name = Global.data.buff.blue_charge.name
	blue_charge_buff.description = Global.data.buff.blue_charge.description
	blue_charge_buff.icon_path = Global.buff_icon.blue_charge
	blue_charge_buff.value = 0
	blue_charge_buff.show_value = true
	return blue_charge_buff

#釋放
func blue_charge_release(player: Player, blue_charge_buff: BlueCharge) -> void:
	if blue_charge_buff.value < discharge_count:
		return
	player.draw_card()
	#藍ADC自動攻擊、藍APT獲得護盾、重裝調整攻擊
	for piece: Piece in Global.board_pieces.filter(filter_ally_piece):
		if piece.show_name == Global.data.card.blue.name + Global.data.card.default_name.adc:
			piece.auto_attack()
		if piece.show_name == Global.data.card.blue.name + Global.data.card.default_name.apt:
			piece.shielded(1, null)
	for piece: Piece in Global.get_all_pieces(player):
		if piece.show_name == Global.data.card.blue.name + Global.data.card.default_name.hf:
			piece.attack_component.atk -= discharge_count
			piece.refresh()

#過濾出除自己外的友方
func filter_ally_piece(piece: Piece, player: Player) -> bool:
	if piece.card_owner == null:
		return false
	return piece.card_owner.id == player.id
