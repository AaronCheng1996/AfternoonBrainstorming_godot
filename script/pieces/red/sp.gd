extends Piece
class_name RedSP

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.sp
	description = Global.data.piece.red.sp
