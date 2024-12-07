extends Piece
class_name WhiteAss

func _init() -> void:
	show_name = "白色刺客"
	description = "[b]先攻[/b]"

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass
