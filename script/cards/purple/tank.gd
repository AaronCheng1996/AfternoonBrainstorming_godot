extends Piece
class_name PurpleTank

var value : int = 2

func _init() -> void:
	show_name = Global.data.card.purple.name + Global.data.card.default_name.tank
	description = Global.data.card.purple.tank.format([str(value)])

func trigger_effect(piece: Piece) -> void:
	var temp = attack_component.atk
	attack_component.atk = value
	print(value)
	attack_component.hit(piece)
	attack_component.atk = temp
