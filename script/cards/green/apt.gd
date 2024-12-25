extends Piece
class_name GreenAPT

var green = preload("res://script/cards/green/green.gd").new()
var buff_value : int = 1
const directions = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.apt
	description = Global.data.card.green.apt.format([str(buff_value)])

func on_turn_start(player_turn: int) -> void:
	if player_turn == card_owner.id:
		#生成箱子
		for i: Vector2i in directions:
			green.create_lucky_box(location + i)

func attack() -> void:
	super.attack()
	for i: Vector2i in directions:
		green.create_lucky_box(location + i)
