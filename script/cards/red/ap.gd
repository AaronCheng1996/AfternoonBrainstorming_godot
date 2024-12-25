extends Piece
class_name RedAP

var red = preload("res://script/cards/red/red.gd").new()
var buff_value : int = 100

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.ap
	description = Global.data.card.red.ap.format([str(buff_value)])

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.has_node("AttackComponent"):
		return
	if not has_node("BuffComponent"):
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		target.add_buff(Global.get_stun_debuff())
	if target.attack_component.atk == 0: #對手攻擊為 0 不用偷
		return
	#降低對手攻擊
	var attack_debuff = AttackBuff.new()
	attack_debuff.show_name = Global.data.buff.attack_stolen.name
	attack_debuff.description = Global.data.buff.attack_stolen.description
	attack_debuff.tag.append_array([Global.BuffTag.DEBUFF])
	attack_debuff.value = -target.attack_component.atk
	target.add_buff(attack_debuff)
	#獲得等額攻擊
	red.attack_buff(-attack_debuff.value, self)
