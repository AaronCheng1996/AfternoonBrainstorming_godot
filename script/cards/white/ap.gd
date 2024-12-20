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
	var stun_debuff = Stun.new()
	stun_debuff.show_name = Global.data.buff.stun.name
	stun_debuff.description = Global.data.buff.stun.description
	stun_debuff.tag.append_array([Global.BuffTag.DEBUFF, Global.BuffTag.STUN])
	stun_debuff.icon_path = Global.buff_icon.stun
	stun_debuff.duration = 1
	target.add_buff(stun_debuff)
