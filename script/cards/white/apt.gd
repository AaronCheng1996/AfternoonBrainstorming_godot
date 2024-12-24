extends Piece
class_name WhiteAPT

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.apt

func refresh() -> void:
	if has_node("AttackComponent"):
		var text = str(attack_component.atk)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.card.white.apt.format([text])
	super.refresh()

#攻擊時為最近友方附加兩點護盾
func attack() -> void:
	if has_node("AttackComponent"):
		super.attack()
		#給自己附加護盾
		shielded(attack_component.atk, self)
		#給友方附加護盾
		var allys = attack_component.find_nearest_target(location, Global.board_pieces.filter(filter_ally_piece))
		allys = allys.filter(func(element: Piece): return !element.is_dead)
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			allys[random_index].shielded(attack_component.atk, self)
		
