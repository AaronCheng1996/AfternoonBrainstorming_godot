extends Piece
class_name WhiteAP

func _init() -> void:
	show_name = Global.data.piece.white.name + Global.data.piece.default_name.ap
	description = Global.data.piece.white.ap

func _on_attack_component_on_hit(target: Piece) -> void:
	var stun_debuff = Stun.new()
	stun_debuff.name = Global.data.buff.stun.name
	stun_debuff.description = Global.data.buff.stun.description
	stun_debuff.tag.append(Global.BuffTag.DEBUFF)
	stun_debuff.duration = 1
	target.buff_component.add_buff(stun_debuff)
