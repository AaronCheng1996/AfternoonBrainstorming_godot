extends Piece
class_name RedLF

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.lf
	description = Global.data.card.red.lf.format([str(buff_value)])

#造成傷害增加攻擊力
func _on_attack_component_on_hit(target: Piece) -> void:
	red.attack_buff(buff_value, self)
	red.buff_health(buff_value, self)
