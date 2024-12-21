extends Buff
class_name AttackBuff

func apply_buff(target):
	if target.has_node("AttackComponent"):
		target.attack_component.atk += value

func remove_buff(target):
	if target.has_node("AttackComponent"):
		target.attack_component.atk -= value
