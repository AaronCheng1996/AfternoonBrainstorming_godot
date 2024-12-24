extends Piece
class_name OrangeLF

func _init() -> void:
	show_name = Global.data.card.orange.name + Global.data.card.default_name.lf
	description = Global.data.card.orange.lf.format([str(3)])

func refresh() -> void:
	if has_node("AttackComponent"):
		var text = str(attack_component.atk)
		Global.set_font_color(text, Global.get_font_color(attack_component.atk, attack_component.DEFAULT_ATK))
		description = Global.data.card.orange.lf.format([text])
	super.refresh()

func attack() -> void:
	super.attack()
	if not buff_component.has_buff(Global.data.buff.move.name):
		add_buff(Global.get_move_buff())

func after_move() -> void:
	Global.piece_moved(self)
	#打最近
	var pieces = Global.board_pieces.filter(filter_opponent_piece)
	var targets = attack_component.find_nearest_target(location, pieces)
	targets = targets.filter(func(element: Piece): return !element.is_dead)
	if targets.size() > 0:
		var random_index = Global.rng.randi_range(0, targets.size() - 1)
		attack_component.hit(targets[random_index])
