extends Piece
class_name WhiteTank

func _init() -> void:
	show_name = Global.data.card.white.tank.show_name
	description = Global.data.card.white.tank.description
	hint = Global.data.card.white.tank.hint
	piece_type = Global.PieceType.TANK
