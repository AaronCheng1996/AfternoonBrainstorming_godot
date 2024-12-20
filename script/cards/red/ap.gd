extends Piece
class_name RedAP

const Red = preload("res://script/cards/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 100

func _ready() -> void:
	red = Red.new()
	super._ready()

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.ap
	description = Global.data.card.red.ap.format([str(buff_value)])

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.has_node("AttackComponent"):
		return
	if not has_node("BuffComponent"):
		return
	if target.attack_component.atk == 0:
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		var stun_debuff = Stun.new()
		stun_debuff.show_name = Global.data.buff.stun.name
		stun_debuff.description = Global.data.buff.stun.description
		stun_debuff.tag.append_array([Global.BuffTag.DEBUFF, Global.BuffTag.STUN])
		stun_debuff.icon_path = Global.buff_icon.stun
		stun_debuff.duration = 1
		target.add_buff(stun_debuff)
	#降低對手攻擊
	var attack_debuff = AttackBuff.new()
	attack_debuff.show_name = Global.data.buff.attack_stolen.name
	attack_debuff.description = Global.data.buff.attack_stolen.description
	attack_debuff.tag.append_array([Global.BuffTag.DEBUFF])
	attack_debuff.icon_path = Global.buff_icon.attack_debuff
	attack_debuff.value = -target.attack_component.atk * buff_value / 100.0
	target.add_buff(attack_debuff)
	buff_target = [self]
	#獲得等額攻擊
	buff_target.append_array(red.get_red_sp(card_owner.on_board))
	var attack_buff = red.create_attack_buff(-attack_debuff.value)
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.add_buff(attack_buff)
