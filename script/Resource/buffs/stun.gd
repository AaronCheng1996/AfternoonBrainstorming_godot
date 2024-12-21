extends Buff
class_name Stun

func apply_buff(target: Piece) -> void:
	#無法主動攻擊
	if target.has_node("OutfitComponent"):
		target.outfit_component.disable_attack()
	#無法移動
	if target.has_node("OutfitComponent"):
		target.outfit_component.disable_move()
	#無法得分
	if target.has_node("ScoreComponent"):
		value = target.score_component.score
		target.score_component.score -= value

func remove_buff(target: Piece) -> void:
	#恢復攻擊
	if target.has_node("OutfitComponent"):
		target.outfit_component.enable_attack()
	#恢復移動
	if target.has_node("OutfitComponent"):
		target.outfit_component.enable_move()
	#恢復得分
	if value == 0:
		return
	if target.has_node("ScoreComponent"):
		target.score_component.score += value
