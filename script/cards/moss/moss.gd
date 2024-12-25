extends Node
class_name Moss

#獲得符文
func add_rune(player: Player, value: int = 1) -> void:
	if player == null:
		return
	if not player.has_node("BuffComponent"):
		return
	if value == 0:
		return
	if not player.buff_component.has_buff(Global.data.buff.rune.name):
		player.buff_component.add_buff(get_rune_buff())
	var rune_buff = player.buff_component.get_buff(Global.data.buff.rune.name)
	for i in range(get_sp_count(player)):
		value *= 2
	rune_buff.value += value
	player.buff_component.show_buff()
	var trigger_list = [
		Global.data.card.moss.name + Global.data.card.default_name.adc,
		Global.data.card.moss.name + Global.data.card.default_name.ap,
		Global.data.card.moss.name + Global.data.card.default_name.apt,
		Global.data.card.moss.name + Global.data.card.default_name.ass,
		Global.data.card.moss.name + Global.data.card.default_name.hf,
		Global.data.card.moss.name + Global.data.card.default_name.lf,
		Global.data.card.moss.name + Global.data.card.default_name.sp,
		Global.data.card.moss.name + Global.data.card.default_name.tank
	]
	for piece: Card in Global.get_show_pieces(player):
		if not trigger_list.has(piece.show_name):
			continue
		piece.refresh()

#取得符文數
func get_rune_count(player: Player) -> int:
	if player == null:
		return 0
	if not player.has_node("BuffComponent"):
		return 0
	if not player.buff_component.has_buff(Global.data.buff.rune.name):
		player.buff_component.add_buff(get_rune_buff())
	return player.buff_component.get_buff(Global.data.buff.rune.name).value

#取得墨綠sp數
func get_sp_count(player: Player) -> int:
	var count: int = 0
	for piece: Card in Global.board_pieces:
		if not piece.show_name == Global.data.card.moss.name + Global.data.card.default_name.sp:
			continue
		if piece.card_owner == player:
			count += 1
	return count

#取得藍球buff
func get_rune_buff() -> Buff:
	var rune_buff: Rune = Rune.new()
	rune_buff.show_name = Global.data.buff.rune.name
	rune_buff.description = Global.data.buff.rune.description
	rune_buff.value = 0
	rune_buff.show_value = true
	return rune_buff
