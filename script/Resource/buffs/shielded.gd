extends Buff
class_name Shielded

func apply_buff(target):
	if target.has_node("HealthComponent"):
		target.health_component.shield += value
