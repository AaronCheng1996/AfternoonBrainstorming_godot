extends Piece
class_name PurpleHF

var value : int = 3

func _init() -> void:
	show_name = Global.data.card.purple.name + Global.data.card.default_name.hf
	description = Global.data.card.purple.hf.format([str(value)])

#回合開始時
func on_turn_start(current_turn: int) -> void:
	if current_turn == card_owner.id:
		var count = 0
		for piece: Piece in Global.board_pieces.filter(filter_opponent_piece_only):
			if attack_component.in_attack_range(location, piece.location):
				count += 1
		card_owner.add_attack_count(count / 3)
	super.on_turn_start(current_turn)
