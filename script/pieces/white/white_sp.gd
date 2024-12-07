extends Piece
class_name WhiteSP

func _init() -> void:
	show_name = "白色鑽石"

"""
#回合結束時
func on_turn_end(player_turn: int) -> void:
	
	if player_turn != player:
		return
	#增加得分buff
	if buff_component:
		var result = buff_component.active_buffs.filter(func(buff):
			return buff.name == "Self Buff"
		)
		if result.size() > 0:
			result[0].value += 1
			result[0].description = "Gain extra {0} score".format([result[0].value])
		else:
			var score_buff = ScoreBuff.new()
			score_buff.name = "Self Buff"
			score_buff.value = 1
			score_buff.description = "Gain extra {0} score".format([score_buff.value])
			score_buff.tag.append_array(["buff"])
			buff_component.add_buff(score_buff)
	tick()
"""
