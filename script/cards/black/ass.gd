extends Piece
class_name BlackAss

var minus : int = 3
var count : int = 0
var count_show : int = 0
var default_count : int = 0

func _init() -> void:
	show_name = Global.data.card.black.ass.show_name
	description = Global.data.card.black.ass.description.format([str(0), str(minus)])
	hint = Global.data.card.black.ass.hint
	piece_type = Global.PieceType.ASS

func _process(delta: float) -> void:
	if card_owner != null:
		count = Global.board_pieces.filter(filter_opponent_piece_only).size() - Global.board_pieces.filter(filter_ally_piece).size()
		if (count != count_show):
			count_show = count
			var text = str(count)
			text = Global.set_font_color(text, Global.get_font_color(count, default_count))
			description = Global.data.card.black.ass.description.format([text, str(minus)])

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	count = Global.board_pieces.filter(filter_opponent_piece_only).size() - Global.board_pieces.filter(filter_ally_piece).size()
	for i in range(count - minus):
		card_owner.draw_card()
