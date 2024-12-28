extends Piece
class_name OrangeHero

var condition : int = 8
var current : int = 0

func _init() -> void:
	show_name = Global.data.card.orange.hero.show_name
	description = Global.data.card.orange.hero.description.format([str(condition), str(condition / 2), str(0)])
	hint = Global.data.card.orange.hero.hint
	piece_type = Global.PieceType.HERO

func trigger_effect(piece: Piece) -> void:
	var text = ""
	current += 1
	if current >= condition:
		current = condition
		text = Global.set_font_color(str(current), Global.ready_color)
	else:
		text = str(current)
	description = Global.data.card.orange.hero.description.format([str(condition), str(condition / 2), text])

func on_piece_set() -> void:
	if current >= condition:
		for i in range(condition / 2):
			Global.get_move_spell(card_owner)
		current = 0
		description = Global.data.card.orange.hero.description.format([str(condition), str(condition / 2), str(current)])
	super.on_piece_set()
