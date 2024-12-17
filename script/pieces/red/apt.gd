extends Piece
class_name RedAPT

const Red = preload("res://script/pieces/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 1

func _ready() -> void:
	red = Red.new()
	refresh()

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.apt
	description = Global.data.piece.red.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack(pieces: Array) -> void:
	if attack_component:
		#生成buff
		var attack_buff = red.create_attack_buff(buff_value)
		var health_buff = red.create_health_buff(buff_value)
		#給友方
		var allys = attack_component.find_nearest_target(location, piece_owner.on_board.filter(filter_ally_piece))
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			buff_target.append(allys[random_index])
		#給予紅sp
		buff_target.append_array(red.get_red_sp(piece_owner.on_board))
		if buff_target.size() > 0:
			for piece: Piece in buff_target:
				piece.add_buff(attack_buff)
				piece.add_buff(health_buff)
		#執行攻擊
		super.attack(pieces)
