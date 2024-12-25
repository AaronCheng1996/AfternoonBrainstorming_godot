extends Piece
class_name WhiteSP

func _init() -> void:
	show_name = Global.data.card.white.name + Global.data.card.default_name.sp

func refresh() -> void:
	var text = str(score_component.score - 1)
	Global.set_font_color(text, Global.get_font_color(score_component.score, score_component.DEAFULT_SCORE))
	description = Global.data.card.white.sp.format([text])
	super.refresh()
