extends Piece
class_name RedTank

var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.tank
	description = Global.data.piece.red.tank.format([str(buff_value)])
