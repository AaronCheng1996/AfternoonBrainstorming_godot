extends Spell
class_name MoveSpell

func _init() -> void:
	show_name = Global.data.card.spell.spell_name.move
	description = Global.data.card.spell.spell_description.move

#施放目標是否符合
func is_valid(board: Dictionary, target: Vector2i) -> bool:
	if get_valid_location(board).has(target):
		return true
	return false

#取得可放置範圍
func get_valid_location(board: Dictionary) -> Array:
	var result := []
	for key in board.keys():
		if board[key] is int:
			continue
		if not board[key].has_node("BuffComponent"):
			continue
		if board[key].buff_component.has_buff(Global.data.buff.move.name): #不疊加
			continue
		result.append(Global.string_to_vector2i(key))
	return result

#效果
func effect(board: Dictionary, target: Vector2i) -> void:
	var move_buff: Move = Move.new()
	move_buff.show_name = Global.data.buff.move.name
	move_buff.description = Global.data.buff.move.description
	move_buff.duration = 1
	move_buff.icon_path = Global.buff_icon.move
	move_buff.tag.append_array([Global.BuffTag.BUFF, Global.BuffTag.MOVE])
	board[str(target)].add_buff(move_buff)
