extends Piece
class_name GreenAP

var green = preload("res://script/cards/green/green.gd").new()

func _init() -> void:
	show_name = Global.data.card.green.name + Global.data.card.default_name.ap
	description = Global.data.card.green.ap

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.has_node("AttackComponent"):
		return
	if not has_node("BuffComponent"):
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		target.add_buff(Global.get_stun_debuff())
	#對手厄運事件
	green.unlucky_event(target)
	#自己幸運事件
	green.lucky_event(self)
