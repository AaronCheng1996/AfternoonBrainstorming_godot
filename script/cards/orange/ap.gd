extends Piece
class_name OrangeAP

var value : int = 1

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.ap
	description = Global.data.card.orange.ap.format([str(value)])

#回合開始時
func on_turn_start(current_turn: int) -> void:
	if not is_on_board:
		return
	if is_dead:
		return
	if current_turn == card_owner.id:
		Global.get_move_spell(card_owner)

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.has_node("BuffComponent"):
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		target.add_buff(Global.get_stun_debuff())
