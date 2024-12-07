extends Piece
class_name WhiteAP

func _init() -> void:
	show_name = "白色圓形"
	description = "[b]攻擊附加[/b]：[b]暈眩[/b]"

func _on_attack_component_on_hit(target: Piece) -> void:
	var stun_debuff = Stun.new()
	stun_debuff.name = "stun"
	stun_debuff.description = "This piece is stunned.\n Can't attack and gain score"
	stun_debuff.duration = 1
	target.buff_component.add_buff(stun_debuff)
