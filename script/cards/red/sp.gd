extends Piece
class_name RedSP

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.sp
	description = Global.data.card.red.sp
