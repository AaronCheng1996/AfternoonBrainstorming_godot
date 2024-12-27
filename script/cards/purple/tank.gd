extends Piece
class_name PurpleTank

var hit_value : int = 2

func _init() -> void:
	show_name = Global.data.card.purple.tank.show_name
	description = Global.data.card.purple.tank.description.format([str(hit_value)])
	hint = Global.data.card.purple.tank.hint
	piece_type = Global.PieceType.TANK

func trigger_effect(piece: Piece) -> void:
	if is_on_board:
		attack_component.hit(piece, hit_value - attack_component.atk)
