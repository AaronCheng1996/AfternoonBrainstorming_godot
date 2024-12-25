extends Piece
class_name GreenLF

var green = preload("res://script/cards/green/green.gd").new()

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.lf
	description = Global.data.card.green.lf.format([str(4)])

func refresh() -> void:
	if has_node("AttackComponent"):
		var text = str(attack_component.atk * 2)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.card.green.lf.format([text])
	super.refresh()

func _on_attack_component_on_kill(target: Piece) -> void:
	if target.show_name == Global.data.card.token.token_name.lucky_box:
		var enemy = get_nearest_enemy()
		attack_component.hit(enemy, attack_component.atk)
		#機率返刀
		if green.luck_is_trigger(card_owner, 2):
			print("++觸發返刀")
			card_owner.add_attack_count(1)
