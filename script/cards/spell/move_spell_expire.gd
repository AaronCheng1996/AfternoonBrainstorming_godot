extends Spell
class_name MoveSpellExpire

func _init() -> void:
	show_name = Global.data.card.spell_and_token.move.show_name
	description = Global.data.card.spell_and_token.move.description
	hint = Global.data.card.spell_and_token.move.hint

#施放目標是否符合
func is_valid(target: Vector2i) -> bool:
	if get_valid_location().has(target):
		return true
	return false

#取得可放置範圍
func get_valid_location() -> Array:
	var result := []
	for piece: Piece in Global.board_pieces:
		if not piece.has_node("BuffComponent"):
			continue
		if piece.buff_component.has_buff(Global.data.buff.move.name): #不疊加
			continue
		result.append(piece.location)
	return result

#效果
func effect(target: Vector2i) -> void:
	Global.board_dic[str(target)].add_buff(Global.get_move_buff())

#施放完
func used() -> void:
	get_parent().remove_child(self)
	card_owner.hand.pop_at(card_owner.hand.find(self))
	emit_signal("leave_hand", card_owner)
