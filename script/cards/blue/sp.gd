extends Piece
class_name BlueSP

var blue = preload("res://script/cards/blue/blue.gd").new()
var hit_value = 1

var default_count: int = 0
var count: int = 0
var count_show: int = 0

func _init() -> void:
	show_name = Global.data.card.blue.sp.show_name
	description = Global.data.card.blue.sp.description.format([str(hit_value), str(default_count)])
	hint = Global.data.card.blue.sp.hint
	piece_type = Global.PieceType.SP

func _process(delta: float) -> void:
	if card_owner != null:
		count = 0
		count += Global.board_pieces.filter(filter_ally_piece).size()
		count += card_owner.grave.size()
		if (count != count_show):
			count_show = count
			var text = str(count)
			text = Global.set_font_color(text, Global.get_font_color(count, default_count))
			description = Global.data.card.blue.sp.description.format([str(hit_value), text])

func on_piece_set() -> void:
	super.on_piece_set()
	#攻擊隨機敵人
	for i in range(count + 2): #預設 1 次 + 自己在場上 1 次
		attack_component.hit(get_random_enemy(), hit_value - attack_component.atk)
	refresh()
