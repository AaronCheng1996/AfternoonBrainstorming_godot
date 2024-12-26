extends Piece
class_name WhiteHero

var dic = [
	Global.data.card.default_name.adc,
	Global.data.card.default_name.ap,
	Global.data.card.default_name.apt,
	Global.data.card.default_name.ass,
	Global.data.card.default_name.hf,
	Global.data.card.default_name.lf,
	Global.data.card.default_name.sp,
	Global.data.card.default_name.tank,
]
#"res://scenes/cards/white/adc.tscn",
func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.hero
	description = Global.data.card.white.hero

func on_piece_set() -> void:
	super.on_piece_set()
	#棄置手牌
	var n : int = card_owner.hand.size()
	for i in range(n):
		await card_owner.discard(card_owner.hand[n - 1 - i])
	#牌堆、墓地
	loop_cards(card_owner.grave)
	loop_cards(card_owner.deck)
	for i in range(n):
		card_owner.draw_card()

#歷遍牌庫
func loop_cards(cards: Array) -> void:
	for i in range(cards.size()):
		var card = cards.pop_front()
		if card.card_type == Global.CardType.PIECE and card.show_name.begins_with(Global.data.card.white.name):
			card = transform(card)
		cards.append(card)

#轉化
func transform(piece: Piece) -> Piece:
	var parent = piece.get_parent()
	#取得種類
	var types = Global.card_groups.keys()
	types.pop_front() #移除白色
	types.pop_back() #移除魔法牌種類
	types.pop_back() #移除紫色
	var type_index = Global.rng.randi_range(0, types.size() - 1)
	var type = types[type_index]
	#找到對應類型
	var index: int = 0
	for i in range(dic.size()):
		if piece.show_name.ends_with(dic[i]):
			index = i
	#生成棋子
	var new_piece: Piece = load(Global.card_groups[type][index]).instantiate()
	self.add_child(new_piece)
	new_piece.location = piece.location
	new_piece.is_on_board = piece.is_on_board
	new_piece.card_owner = piece.card_owner
	new_piece.is_dead = piece.is_dead
	#保留攻擊
	new_piece.attack_component.DEFAULT_ATK = piece.attack_component.DEFAULT_ATK
	#保留體質
	new_piece.health_component.DEAFULT_MAX_HEALTH = piece.health_component.DEAFULT_MAX_HEALTH
	new_piece.health_component.DEAFULT_SHIELD = piece.health_component.DEAFULT_SHIELD
	#保留得分
	new_piece.score_component.DEAFULT_SCORE = piece.score_component.DEAFULT_SCORE
	new_piece.renew()
	self.remove_child(new_piece)

	return new_piece
