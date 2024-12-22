extends Piece
class_name BlueSP

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value = 1

var default_count: int = 0
var count: int = 0
var count_show: int = 0

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.sp
	description = Global.data.card.blue.sp.format([str(buff_value), str(default_count)])

func _process(delta: float) -> void:
	if card_owner != null:
		count = 0
		count += Global.board_pieces.filter(filter_ally_piece).size()
		count += card_owner.grave.size()
		if (count != count_show):
			count_show = count
			var text = str(count)
			Global.set_font_color(text, Global.get_font_color(count, default_count))
			description = Global.data.card.blue.sp.format([str(buff_value), text])

func on_piece_set() -> void:
	super.on_piece_set()
	#攻擊隨機敵人
	for i in range(count + 2): #預設 1 次 + 自己在場上 1 次
		var emptys = Global.board_pieces.filter(filter_opponent_piece)
		if emptys.size() > 0:
			var random_index = Global.rng.randi_range(0, emptys.size() - 1)
			emptys[random_index].take_damaged(buff_value, self)
