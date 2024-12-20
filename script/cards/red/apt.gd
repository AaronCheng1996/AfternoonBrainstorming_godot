extends Piece
class_name RedAPT

const Red = preload("res://script/cards/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 1

func _ready() -> void:
	red = Red.new()
	super._ready()

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.apt
	description = Global.data.card.red.apt.format([str(buff_value)])

#攻擊時為最近友方附加+1/+1
func attack(board: Dictionary) -> void:
	if has_node("AttackComponent"):
		buff_target = [self]
		#生成buff
		var attack_buff = red.create_attack_buff(buff_value)
		var health_buff = red.create_health_buff(buff_value)
		#給友方
		var allys = attack_component.find_nearest_target(location, card_owner.on_board.filter(filter_ally_piece))
		if allys.size() > 0:
			var random_index = Global.rng.randi_range(0, allys.size() - 1)
			buff_target.append(allys[random_index])
		#給予紅sp
		buff_target.append_array(red.get_red_sp(card_owner.on_board))
		buff_target.append_array(red.get_red_sp(card_owner.on_board))
		if buff_target.size() > 0:
			for piece: Piece in buff_target:
				piece.add_buff(attack_buff)
				piece.add_buff(health_buff)
		#執行攻擊
		super.attack(board)
