extends Piece
class_name RedHF

var cost_value : int = 1
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.hf
	description = Global.data.piece.red.hf.format([str(cost_value), str(buff_value)])
