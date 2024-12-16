extends Piece
class_name RedLF

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.lf
	description = Global.data.piece.red.lf.format([str(buff_value)])
