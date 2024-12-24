extends Buff
class_name DeathDoor


func apply_buff(target: Piece) -> void:
	#無法得分
	if target.has_node("ScoreComponent"):
		value = target.score_component.score
		target.score_component.score -= value

func remove_buff(target: Piece) -> void:
	#恢復得分
	if value == 0:
		return
	if target.has_node("ScoreComponent"):
		target.score_component.score += value

func tick(target: Piece) -> void:
	#死亡
	target.die()
