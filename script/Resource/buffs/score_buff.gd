extends Buff
class_name ScoreBuff

func apply_buff(target):
	if target.has_node("ScoreComponent"):
		target.score_component.score += value

func remove_buff(target):
	if target.has_node("ScoreComponent"):
		target.score_component.score -= value

func add_value(target, add):
	super.add_value(target, add)
	if target.has_node("ScoreComponent"):
		target.score_component.score += value
