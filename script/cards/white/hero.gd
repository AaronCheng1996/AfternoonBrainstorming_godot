extends Piece
class_name WhiteHero

var type: String = ""
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
	#取得種類
	var types = Global.card_groups.keys()
	types.pop_front() #移除白色
	types.pop_back() #移除魔法牌種類
	var index = Global.rng.randi_range(0, types.size() - 1)
	type = types[index]
	#棄置手牌
	var n : int = card_owner.hand.size()
	for i in range(n):
		await card_owner.discard(card_owner.hand[n - 1 - i])
	#牌堆、墓地
	loop_cards(card_owner.deck)
	loop_cards(card_owner.grave)
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
	#保留體質
	var temp_node = piece.attack_component
	piece.remove_child(temp_node)
	new_piece.add_child(temp_node)
	new_piece.attack_component = temp_node
	#保留攻擊
	temp_node = piece.health_component
	piece.remove_child(temp_node)
	new_piece.add_child(temp_node)
	new_piece.health_component = temp_node
	#保留得分
	temp_node = piece.score_component
	piece.remove_child(temp_node)
	new_piece.add_child(temp_node)
	new_piece.score_component = temp_node
	self.remove_child(new_piece)

	return new_piece
