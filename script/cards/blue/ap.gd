extends Piece
class_name BlueAP

var blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 2

func _init() -> void:
	show_name = Global.data.card.blue.name + Global.data.card.default_name.ap
	description = Global.data.card.blue.ap.format([str(buff_value)])

func attack() -> void:
	blue.add_blue_charge(card_owner, buff_value)
	super.attack()

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.has_node("BuffComponent"):
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		target.add_buff(Global.get_stun_debuff())
