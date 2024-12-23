extends Buff
class_name AttackBuff

func apply_buff(target):
	if value > 0:
		icon_path = Global.buff_icon.attack_buff
	else:
		icon_path = Global.buff_icon.attack_debuff
	if target.has_node("AttackComponent"):
		target.attack_component.atk += value

func remove_buff(target):
	if target.has_node("AttackComponent"):
		target.attack_component.atk -= value
