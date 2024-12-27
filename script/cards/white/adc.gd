extends Piece
class_name WhiteADC

func _init() -> void:
	show_name = Global.data.card.white.adc.show_name
	description = Global.data.card.white.adc.description
	hint = Global.data.card.white.adc.hint
	piece_type = Global.PieceType.ADC
