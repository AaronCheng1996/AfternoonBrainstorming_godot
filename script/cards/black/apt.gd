extends Piece
class_name BlackAPT

var percent : int = 100

func _init() -> void:
	show_name = Global.data.card.black.apt.show_name
	description = Global.data.card.black.apt.description.format([str(percent)])
	hint = Global.data.card.black.apt.hint
	piece_type = Global.PieceType.APT

func take_damaged(damage: int, applyer) -> bool:
	var damage_reduced: int = 0
	if applyer != null:
		if applyer.has_node("AttackComponent"):
			damage_reduced = (damage - applyer.attack_component.atk) / 2
			if damage_reduced < 0:
				damage_reduced = 0
	if damage_reduced > 0:
		get_nearest_ally().shielded(damage_reduced * percent / 100, self)
	return super.take_damaged(damage - damage_reduced, applyer)
