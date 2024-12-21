extends Spell
class_name MoveSpell

func _init() -> void:
	show_name = Global.data.card.spell.spell_name.move
	description = Global.data.card.spell.spell_description.move

#施放目標是否符合
func is_valid(target: Vector2i) -> bool:
	if get_valid_location().has(target):
		return true
	return false

#取得可放置範圍
func get_valid_location() -> Array:
	var result := []
	for key in Global.board_dic.keys():
		if Global.board[key] is int:
			continue
		if not Global.board[key].has_node("BuffComponent"):
			continue
		if Global.board[key].buff_component.has_buff(Global.data.buff.move.name): #不疊加
			continue
		result.append(Global.string_to_vector2i(key))
	return result

#效果
func effect(target: Vector2i) -> void:
	Global.board[str(target)].add_buff(Global.get_move_buff())
