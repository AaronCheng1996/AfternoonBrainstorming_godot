extends Piece
class_name WhiteAss

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.ass
	description = Global.data.card.white.ass

#棋子放置時
func on_piece_set(board: Dictionary) -> void:
	refresh()
	pass
