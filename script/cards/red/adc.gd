extends Piece
class_name RedADC

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 1
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.adc
	description = Global.data.card.red.adc.format([str(buff_value)])

func attack() -> void:
	buff_value_sum = 0
	super.attack()
	#最後一次加
	if not has_node("BuffComponent"):
		return
	var attack_buff = red.create_attack_buff(buff_value_sum, card_owner)
	add_buff(attack_buff)

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += buff_value
