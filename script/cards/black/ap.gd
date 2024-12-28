extends Piece
class_name BlackAP

func _init() -> void:
	show_name = Global.data.card.black.ap.show_name
	description = Global.data.card.black.ap.description
	hint = Global.data.card.black.ap.hint
	piece_type = Global.PieceType.AP

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.has_node("BuffComponent"):
		return
	#清除buff並暈眩
	target.clear_buffs()
	target.add_buff(Global.get_stun_debuff())
	#破甲
	if not target.has_node("HealthComponent"):
		return
	target.health_component.shield = 0
