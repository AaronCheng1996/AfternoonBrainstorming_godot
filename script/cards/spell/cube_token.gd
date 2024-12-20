extends Piece
class_name CubeToken

func _init() -> void:
	show_name = Global.data.card.token.token_name.cube
	description = Global.data.card.token.token_description.cube
	card_type = Global.CardType.TOKEN

func die() -> void:
	#預留：動畫位置
	emit_signal("piece_die", self)
