extends Piece
class_name BlackTank

var hit_value : int = 2

func _init() -> void:
	show_name = Global.data.card.black.tank.show_name
	description = Global.data.card.black.tank.description.format([str(hit_value)])
	hint = Global.data.card.black.tank.hint
	piece_type = Global.PieceType.TANK

func trigger_effect(piece: Piece) -> void:
	if is_on_board:
		attack_component.hit(piece, hit_value - attack_component.atk)
