extends Buff
class_name HealthBuff

func apply_buff(target):
	if target.get_node_or_null("HealthComponent"):
		target.health_component.max_health += value
		target.health_component.health += value

func remove_buff(target):
	if target.get_node_or_null("HealthComponent"):
		target.health_component.max_health -= value
