extends Piece
class_name RedAP

const Red = preload("res://script/pieces/red/red.gd")
var red: Red
var buff_target := [self]
var buff_value : int = 100

func _ready() -> void:
	red = Red.new()
	refresh()

func _init() -> void:
	show_name = Global.data.piece.red.name + Global.data.piece.default_name.ap
	description = Global.data.piece.red.ap.format([str(buff_value)])

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.attack_component:
		return
	if not buff_component:
		return
	if target.attack_component.atk == 0:
		return
	#降低對手攻擊
	var attack_debuff = AttackBuff.new()
	attack_debuff.name = Global.data.buff.attack_stolen.name
	attack_debuff.description = Global.data.buff.attack_stolen.description
	attack_debuff.tag.append_array([Global.BuffTag.DEBUFF])
	attack_debuff.icon_path = Global.buff_icon.attack_debuff
	attack_debuff.value = -target.attack_component.atk * buff_value / 100.0
	target.add_buff(attack_debuff)
	#獲得等額攻擊
	buff_target.append_array(red.get_red_sp(piece_owner.on_board))
	var attack_buff = red.create_attack_buff(-attack_debuff.value)
	if buff_target.size() > 0:
		for piece: Piece in buff_target:
			piece.add_buff(attack_buff)
