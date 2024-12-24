extends Buff
class_name HealthBuff

func apply_buff(target):
	if value > 0:
		icon_path = Global.buff_icon.health_buff
	else:
		icon_path = Global.buff_icon.health_debuff
	if target.has_node("HealthComponent"):
		target.health_component.max_health += value
		target.health_component.health += value

func remove_buff(target):
	if target.has_node("HealthComponent"):
		target.health_component.max_health -= value
		if target.health_component.health <= target.health_component.max_health:
			return
		target.health_component.health = target.health_component.max_health
