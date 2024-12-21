extends Piece
class_name WhiteAP

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.ap
	description = Global.data.card.white.ap

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.has_node("BuffComponent"):
		return
	if target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		return
	target.add_buff(Global.get_stun_debuff())
