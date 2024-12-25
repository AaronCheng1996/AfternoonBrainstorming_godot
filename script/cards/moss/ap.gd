extends Piece
class_name MossAP

var moss = preload("res://script/cards/moss/moss.gd").new()
var buff_value : int = 3
var default_icon = preload("res://img/piece/standerd/dark_green.png")
var half_power_icon = preload("res://img/piece/standerd/dark_green_half_powered.png")
var empower_icon = preload("res://img/piece/standerd/dark_green_empowered.png")

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.ap
	description = Global.data.card.moss.ap.format([str(buff_value)])

func refresh() -> void:
	#更改圖示
	var power = moss.get_rune_count(card_owner)
	if power < 20 and outfit_component.icon.texture != default_icon:
		outfit_component.icon.texture = default_icon
	if power >= 20 and power < 50 and outfit_component.icon.texture != half_power_icon:
		outfit_component.icon.texture = half_power_icon
	if power >= 50 and outfit_component.icon.texture != empower_icon:
		outfit_component.icon.texture = empower_icon

func on_turn_start(player_turn) -> void:
	if player_turn == card_owner.id:
		moss.add_rune(card_owner, buff_value)
	super.on_turn_start(player_turn)

func _on_attack_component_on_hit(target: Piece) -> void:
	if not target.buff_component or not target.has_node("AttackComponent"):
		return
	if not has_node("BuffComponent"):
		return
	#給予暈眩
	if not target.buff_component.has_buff(Global.data.buff.stun.name): #不疊加
		target.add_buff(Global.get_stun_debuff())
