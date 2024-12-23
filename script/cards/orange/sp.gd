extends Piece
class_name OrangeSP

var hit_value = 3

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.sp
	description = Global.data.card.orange.sp.format([str(hit_value)])

func trigger_effect(piece: Piece) -> void:
	if not is_on_board:
		return
	var temp_atk = attack_component.atk
	attack_component.atk = hit_value
	attack()
	attack_component.atk = temp_atk
