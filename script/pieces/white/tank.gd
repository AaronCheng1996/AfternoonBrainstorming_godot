extends Piece
class_name WhiteTank

func _init() -> void:
	show_name = Global.data.piece.white.name + Global.data.piece.default_name.tank
