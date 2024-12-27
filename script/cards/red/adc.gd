extends Piece
class_name RedADC

var red: Red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.red.adc.show_name
	description = Global.data.card.red.adc.description.format([str(buff_value)])
	hint = Global.data.card.red.adc.hint
	piece_type = Global.PieceType.ADC

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	red.attack_buff(buff_value, self)
