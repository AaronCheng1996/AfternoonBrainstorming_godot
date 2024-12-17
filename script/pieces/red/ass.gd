extends Piece
class_name RedAss

const Red = preload("res://script/pieces/red/red.gd")
var red: Red
var buff_target := []
var buff_value : int = 2
var buff_value_sum : int = 0

func _ready() -> void:
	red = Red.new()
	refresh()
	
func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.ass
	description = Global.data.piece.red.ass.format([str(buff_value)])

#棋子放置時
func on_piece_set(pieces: Array) -> void:
	refresh()
	pass

func attack(pieces: Array) -> void:
	buff_value_sum = 0
	super.attack(pieces)
	#最後一次加
	if not buff_component:
		return
	#給友方
	var allys = attack_component.find_nearest_target(location, piece_owner.on_board.filter(filter_ally_piece))
	if allys.size() > 0:
		var random_index = Global.rng.randi_range(0, allys.size() - 1)
		buff_target.append(allys[random_index])
	buff_target.append_array(red.get_red_sp(piece_owner.on_board))
	var attack_buff = red.create_attack_buff(buff_value_sum)
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.add_buff(attack_buff)

func _on_attack_component_on_kill(target: Piece) -> void:
	buff_value_sum += buff_value
