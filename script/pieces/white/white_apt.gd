extends Piece
class_name WhiteAPT

func _init() -> void:
	show_name = Global.data.piece.white.name + Global.data.piece.default_name.apt

func refresh() -> void:
	super.refresh()
	if attack_component:
		var text = str(attack_component.atk)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.piece.white.apt.format([text])

#攻擊時為最近友方附加兩點護盾
func attack(pieces: Array) -> void:
	if attack_component:
		pieces = pieces.filter(filter_piece_on_board)
		#給自己附加護盾
		health_component.shielded(attack_component.atk)
		#給友方附加護盾
		var allys = pieces.filter(filter_ally_piece)
		allys = attack_component.find_nearest_target(location, allys)
		if allys.size() == 0:
			return
		var random_index = Global.rng.randi_range(0, allys.size() - 1)
		allys[random_index].shielded(attack_component.atk, self)
		#敵方
		var enemys = pieces.filter(filter_opponent_piece)
		attack_component.attack(enemys)
