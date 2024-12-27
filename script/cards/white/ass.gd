extends Piece
class_name WhiteAss

func _init() -> void:
	show_name = Global.data.card.white.ass.show_name
	description = Global.data.card.white.ass.description
	hint = Global.data.card.white.ass.hint
	piece_type = Global.PieceType.ASS

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass
