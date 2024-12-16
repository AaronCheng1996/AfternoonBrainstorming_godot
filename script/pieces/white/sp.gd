extends Piece
class_name WhiteSP

func _init() -> void:
	show_name = Global.data.piece.white.name + Global.data.piece.default_name.sp

func refresh() -> void:
	super.refresh()
	if score_component:
		var text = str(score_component.score - 1)
		Global.set_font_color(text, Global.get_font_color(score_component.score, score_component.DEAFULT_SCORE))
		description = Global.data.piece.white.sp.format([text])
