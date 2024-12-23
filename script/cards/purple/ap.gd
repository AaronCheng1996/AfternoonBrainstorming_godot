extends Piece
class_name PurpleAP

func _init() -> void:
	show_name = Global.data.card.purple.name + Global.data.card.default_name.ap
	description = Global.data.card.purple.ap

func attack() -> void:
	super.attack()

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.has_node("BuffComponent"):
		return
	target.clear_buffs()
	target.add_buff(Global.get_stun_debuff())
	#破甲
	if not target.has_node("BuffComponent"):
		return
	target.health_component.shield = 0
