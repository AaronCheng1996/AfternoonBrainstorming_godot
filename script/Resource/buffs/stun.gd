extends Buff
class_name Stun

func apply_buff(target) -> void:
	#無法主動攻擊
	if target.get_node_or_null("OutfitComponent"):
		target.outfit_component.disable_attack()
	#無法得分
	if target.get_node_or_null("ScoreComponent"):
		value = target.score_component.score
		target.score_component.score -= value

func remove_buff(target) -> void:
	#恢復攻擊
	if target.get_node_or_null("ScoreComponent"):
		target.outfit_component.enable_attack()
	#恢復得分
	if value == 0:
		return
	if target.get_node_or_null("ScoreComponent"):
		target.score_component.score += value
