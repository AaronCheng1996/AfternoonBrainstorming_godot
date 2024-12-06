extends Piece
class_name WhiteAP

func _on_attack_component_on_hit(target: Piece) -> void:
	var stun_debuff = Stun.new()
	stun_debuff.name = "stun"
	stun_debuff.duration = 1
	target.buff_component.add_buff(stun_debuff)
