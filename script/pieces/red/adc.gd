extends Piece
class_name RedADC

const Red = preload("res://script/pieces/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 1
var buff_value_sum : int = 0

func _ready() -> void:
	red = Red.new()
	refresh()

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.adc
	description = Global.data.piece.red.adc.format([str(buff_value)])

func attack(pieces: Array) -> void:
	buff_value_sum = 0
	super.attack(pieces)
	#最後一次加
	if not buff_component:
		return
	buff_target.append_array(red.get_red_sp(piece_owner.on_board))
	var attack_buff = red.create_attack_buff(buff_value_sum)
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.add_buff(attack_buff)

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += buff_value
