extends Piece
class_name OrangeSP

var hit_value = 3

func _init() -> void:
	show_name = Global.data.card.orange.sp.show_name
	description = Global.data.card.orange.sp.description.format([str(hit_value)])
	hint = Global.data.card.orange.sp.hint
	piece_type = Global.PieceType.SP

func trigger_effect(piece: Piece) -> void:
	if not is_on_board:
		return
	attack_component.hit(get_random_enemy(), hit_value - attack_component.atk)
