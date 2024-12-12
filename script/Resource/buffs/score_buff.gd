extends Buff
class_name ScoreBuff

func apply_buff(target):
	if target.get_node_or_null("ScoreComponent"):
		target.score_component.score += value

func remove_buff(target):
	if target.get_node_or_null("ScoreComponent"):
		target.score_component.score -= value
