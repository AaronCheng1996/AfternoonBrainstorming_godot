extends Piece
class_name WhiteLF

func _init() -> void:
	show_name = Global.data.card.white.lf.show_name
	description = Global.data.card.white.lf.description
	hint = Global.data.card.white.lf.hint
	piece_type = Global.PieceType.LF
