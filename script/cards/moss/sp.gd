extends Piece
class_name MossSP

var moss = preload("res://script/cards/moss/moss.gd").new()

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.sp
	description = Global.data.card.moss.sp

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
