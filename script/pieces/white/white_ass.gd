extends Piece
class_name WhiteAss

func _init() -> void:
	show_name = Global.data.piece.white.name + Global.data.piece.default_name.ass
	description = Global.data.piece.white.ass

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass
