extends Piece
class_name MossAss

var moss = preload("res://script/cards/moss/moss.gd").new()
var buff_value : int = 4
	
func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.ass
	description = Global.data.card.moss.ass.format([str(buff_value)])

func refresh() -> void:
	#更改圖示
	moss.update_icon(self)

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	moss.add_rune(card_owner, buff_value)
