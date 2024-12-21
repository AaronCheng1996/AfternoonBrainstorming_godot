extends Card
class_name Spell

signal add_piece_to_board(piece: Piece, location: Vector2i)
signal leave_hand(player: Player)

var card_type : Global.CardType = Global.CardType.SPELL
@export var target_type : Global.TargetType = Global.TargetType.NONE
@export var expirable : bool = false
@export var outfit_component : OutfitComponent

#取得可放置範圍
func get_valid_location() -> Array:
	return []

#region 動作
#選取特效
func show_select_effect() -> void:
	#預留：選取動畫
	if has_node("OutfitComponent") and not is_on_board:
		outfit_component.show_control_panel()
func hide_select_effect() -> void:
	#預留：選取動畫
	if has_node("OutfitComponent"):
		outfit_component.hide_control_panel()
#施放
func cast(target: Vector2i) -> bool:
	if not is_valid(target):
		return false
	used()
	effect(target)
	return true

#效果
func effect(target: Vector2i) -> void:
	pass

#施放完
func used() -> void:
	get_parent().remove_child(self)
	card_owner.hand.pop_at(card_owner.hand.find(self))
	card_owner.grave.append(self)
	emit_signal("leave_hand", card_owner)

#消逝
func expire() -> void:
	get_parent().remove_child(self)
	card_owner.hand.pop_at(card_owner.hand.find(self))
	emit_signal("leave_hand", card_owner)
#endregion

#region 過濾
#施放目標是否符合
func is_valid(target: Vector2i) -> bool:
	match target_type:
		Global.TargetType.NONE:
			return true
		Global.TargetType.BOARD:
			return Global.board_dic[str(target)] is int
		Global.TargetType.PIECE:
			return Global.board_dic[str(target)] is not int
	return false
#過濾出場上棋子
func filter_piece_on_board(piece: Piece):
	return piece.is_on_board
#過濾出除自己外的友方
func filter_ally_piece(piece: Piece):
	return piece.card_owner.id == card_owner.id and piece.location != location
#過濾出敵方
func filter_opponent_piece(piece: Piece):
	return piece.card_owner.id != card_owner.id
#endregion
