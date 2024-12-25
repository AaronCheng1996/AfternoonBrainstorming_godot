extends Piece
class_name WhiteAPT

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.apt

func refresh() -> void:
	var text = str(attack_component.atk)
	Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
	description = Global.data.card.white.apt.format([text])
	super.refresh()

#攻擊時為最近友方附加兩點護盾
func attack() -> void:
	super.attack()
	#給自己附加護盾
	shielded(attack_component.atk, self)
	#給友方附加護盾
	var ally = get_nearest_ally()
	if ally != null:
		ally.shielded(attack_component.atk, self)
		
