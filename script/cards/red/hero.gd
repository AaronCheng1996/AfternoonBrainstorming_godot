extends Piece
class_name RedHero

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.hero
	description = Global.data.card.red.hero

#抽起時
func on_draw() -> void:
	card_owner.draw_card()

#棋子放置時
func on_piece_set() -> void:
	#清除手牌
	card_owner.grave.append_array(card_owner.hand)
	var n : int = card_owner.hand.size()
	for i in range(n):
		card_owner.discard(card_owner.hand[n - 1 - i])
	#清除場上
	var allys = Global.board_pieces.filter(filter_ally_piece)
	for ally: Piece in allys:
		ally.die()
	#獲得增益
	for buff: Buff in card_owner.buff_history:
		if buff.tag.has(Global.BuffTag.RED):
			add_buff(buff)
	#獲得一刀
	card_owner.add_attack_count(1)
	refresh()

func attack() -> void:
	super.attack()
	var pieces = Global.board_pieces.filter(filter_opponent_piece).filter(func(element: Piece): return !element.is_dead)
	var targets = attack_component.find_nearest_target(location, pieces)
	if targets.size() > 0:
		var random_index = Global.rng.randi_range(0, targets.size() - 1)
		attack_component.hit(targets[random_index])
