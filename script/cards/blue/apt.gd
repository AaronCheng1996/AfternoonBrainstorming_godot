extends Piece
class_name BlueAPT

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 1

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.apt
	description = Global.data.card.blue.apt.format([str(buff_value), str(0)])

func refresh() -> void:
	super.refresh()
	if has_node("HealthComponent"):
		var text = str(health_component.shield / 4)
		Global.set_font_color(text, Global.get_font_color(health_component.shield / 4, health_component.DEAFULT_SHIELD / 4))
		description = Global.data.card.blue.apt.format([str(buff_value), text])

func attack() -> void:
	super.attack()
	if health_component.shield / 4 > 0:
		blue.add_blue_charge(card_owner, health_component.shield / 4)
