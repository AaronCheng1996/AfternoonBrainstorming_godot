extends Piece
class_name OrangeAss

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.ass
	description = Global.data.card.orange.ass

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())
	if buff_component.has_buff(Global.data.buff.rage.name):
		remove_buff(buff_component.get_buff(Global.data.buff.rage.name))
		card_owner.add_attack_count(1)
	
func after_move() -> void:
	Global.piece_moved(self)
	if not buff_component.has_buff(Global.data.buff.rage.name):
		add_buff(Global.get_rage_buff())
