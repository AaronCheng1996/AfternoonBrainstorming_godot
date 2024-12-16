extends Piece
class_name RedAPT

var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.apt
	description = Global.data.piece.red.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack(pieces: Array) -> void:
	pass
