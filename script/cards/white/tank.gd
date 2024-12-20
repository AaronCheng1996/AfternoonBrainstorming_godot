extends Piece
class_name WhiteTank

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.tank
