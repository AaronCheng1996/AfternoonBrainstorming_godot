extends Piece
class_name PurpleTank

var hit_value : int = 2

func _init() -> void:
	show_name = Global.data.card.purple.name + Global.data.card.default_name.tank
	description = Global.data.card.purple.tank.format([str(hit_value)])

func trigger_effect(piece: Piece) -> void:
	if is_on_board:
		attack_component.hit(piece, hit_value - attack_component.atk)
