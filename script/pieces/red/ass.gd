extends Piece
class_name RedAss

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.ass
	description = Global.data.piece.red.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set(pieces: Array) -> void:
	refresh()
	pass
