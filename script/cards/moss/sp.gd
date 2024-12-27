extends Piece
class_name MossSP

var moss = preload("res://script/cards/moss/moss.gd").new()

func _init() -> void:
	show_name = Global.data.card.moss.sp.show_name
	description = Global.data.card.moss.sp.description
	hint = Global.data.card.moss.sp.hint
	piece_type = Global.PieceType.SP

func refresh() -> void:
	#更改圖示
	moss.update_icon(self)

#加倍
func on_piece_set() -> void:
	moss.on_sp_set(card_owner)
	super.on_piece_set()

#減半
func die() -> void:
	moss.on_sp_die(card_owner)
	super.die()
