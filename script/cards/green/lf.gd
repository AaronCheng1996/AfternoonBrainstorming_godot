extends Piece
class_name GreenLF

var green = preload("res://script/cards/green/green.gd").new()
var kill_count : int = 0

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.lf
	description = Global.data.card.green.lf.format([str(4)])

func refresh() -> void:
	super.refresh()
	if has_node("AttackComponent"):
		var text = str(attack_component.atk * 2)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.card.white.apt.format([text])

func attack() -> void:
	kill_count = 0
	super.attack()
	for i in kill_count:
		#打最近
		var pieces = Global.board_pieces.filter(filter_opponent_piece)
		var targets = attack_component.find_nearest_target(location, pieces)
		targets = targets.filter(func(element: Piece): return !element.is_dead)
		if targets.size() > 0:
			var random_index = Global.rng.randi_range(0, targets.size() - 1)
			var temp_atk = attack_component.atk
			attack_component.atk = attack_component.atk * 2
			attack_component.hit(targets[random_index])
			attack_component.atk = temp_atk
		#機率返刀
		if green.luck_is_trigger(card_owner, 2):
			print("++觸發返刀")
			card_owner.add_attack_count(1)

func _on_attack_component_on_kill(target: Piece) -> void:
	if target.show_name == Global.data.card.token.token_name.lucky_box:
		kill_count += 1
