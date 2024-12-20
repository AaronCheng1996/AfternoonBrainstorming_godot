extends Piece
class_name WhiteAPT

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.apt

func refresh() -> void:
	super.refresh()
	if has_node("AttackComponent"):
		var text = str(attack_component.atk)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.card.white.apt.format([text])

#攻擊時為最近友方附加兩點護盾
func attack(board: Dictionary) -> void:
	if has_node("AttackComponent"):
		#給自己附加護盾
		shielded(attack_component.atk, self)
		#給友方附加護盾
		var allys = attack_component.find_nearest_target(location, card_owner.on_board.filter(filter_ally_piece))
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			allys[random_index].shielded(attack_component.atk, self)
		#執行攻擊
		super.attack(board)
