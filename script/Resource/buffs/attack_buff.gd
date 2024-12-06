extends Buff
class_name AttackBuff

var value: int = 0

func apply_buff(target):
	if target.get_node_or_null("AttackComponent"):
		target.attack_component.atk += value

func remove_buff(target):
	if target.get_node_or_null("AttackComponent"):
		target.attack_component.atk -= value
