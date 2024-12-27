extends Piece
class_name WhiteHF

func _init() -> void:
	show_name = Global.data.card.white.hf.show_name
	description = Global.data.card.white.hf.description
	hint = Global.data.card.white.hf.hint
	piece_type = Global.PieceType.HF
