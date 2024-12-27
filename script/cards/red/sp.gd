extends Piece
class_name RedSP

func _init() -> void:
	show_name = Global.data.card.red.sp.show_name
	description = Global.data.card.red.sp.description
	hint = Global.data.card.red.sp.hint
	piece_type = Global.PieceType.SP
