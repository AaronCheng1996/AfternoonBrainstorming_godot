extends Piece
class_name RedLF

const Red = preload("res://script/cards/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 1
var buff_value_sum : int = 0

func _ready() -> void:
	red = Red.new()
	super._ready()

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.lf
	description = Global.data.card.red.lf.format([str(buff_value)])

func attack(board: Dictionary) -> void:
	buff_target = [self]
	buff_value_sum = 0
	super.attack(board)
	#最後一次加
	if not has_node("BuffComponent"):
		return
	var attack_buff = red.create_attack_buff(buff_value_sum)
	var health_buff = red.create_health_buff(buff_value_sum)
	buff_target.append_array(red.get_red_sp(card_owner.on_board))
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.add_buff(attack_buff)
			piece.add_buff(health_buff)

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += buff_value
