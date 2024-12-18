extends Piece
class_name RedTank

const Red = preload("res://script/pieces/red/red.gd")
var red: Red
var buff_target := []
var buff_value : int = 2

func _ready() -> void:
	red = Red.new()
	refresh()

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.tank
	description = Global.data.piece.red.tank.format([str(buff_value)])

#承受傷害，給予隊友 2 盾
func take_damaged(damage: int, applyer) -> bool:
	var result = super.take_damaged(damage, applyer)
	#最接近的友方
	var allys = attack_component.find_nearest_target(location, piece_owner.on_board.filter(filter_ally_piece))
	if allys.size() > 0:
		var random_index = Global.rng.randi_range(0, allys.size() - 1)
		buff_target.append(allys[random_index])
	buff_target.append_array(red.get_red_sp(piece_owner.on_board))
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.shielded(buff_value, self)
	return result
