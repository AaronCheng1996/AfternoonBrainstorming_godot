extends Node
class_name Card

var show_name : String = ""
var description : String = ""
var location : Vector2i
var is_on_board : bool
var card_owner : Player

#抽起時
func on_draw() -> void:
	pass

#棄牌時
func on_discard() -> void:
	pass

#消逝
func expire() -> void:
	pass

func refresh() -> void:
	pass
