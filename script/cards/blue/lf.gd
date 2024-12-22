extends Piece
class_name BlueLF

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 1
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.lf
	description = Global.data.card.blue.lf

func attack() -> void:
	buff_value_sum = 0
	super.attack()
	blue.add_blue_charge(card_owner, buff_value_sum)

func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += buff_value
