extends Piece
class_name MossAPT

var moss = preload("res://script/cards/moss/moss.gd").new()
var rate : int = 50
var buff_value_sum : int = 0

var default_icon = preload("res://img/piece/standerd/dark_green.png")
var half_power_icon = preload("res://img/piece/standerd/dark_green_half_powered.png")
var empower_icon = preload("res://img/piece/standerd/dark_green_empowered.png")	

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.apt
	description = Global.data.card.moss.apt.format([str(0), str(0), str(0)])

func refresh() -> void:
	#更改圖示
	var power = moss.get_rune_count(card_owner)
	if power < 20 and outfit_component.icon.texture != default_icon:
		outfit_component.icon.texture = default_icon
	if power >= 20 and power < 50 and outfit_component.icon.texture != half_power_icon:
		outfit_component.icon.texture = half_power_icon
	if power >= 50 and outfit_component.icon.texture != empower_icon:
		outfit_component.icon.texture = empower_icon
	#更改說明
	var text1 = str(moss.get_rune_count(card_owner) * rate / 100)
	var text2 = str(health_component.shield * rate / 100)
	var text3 = str((moss.get_rune_count(card_owner) * rate / 100 + attack_component.atk) * rate / 100)
	Global.set_font_color(text1, Global.get_font_color(moss.get_rune_count(card_owner) * rate / 100, 0))
	Global.set_font_color(text2, Global.get_font_color(health_component.shield * rate / 100, 0))
	Global.set_font_color(text3, Global.get_font_color((moss.get_rune_count(card_owner) * rate / 100 + attack_component.atk) * rate / 100, attack_component.DEFAULT_ATK))
	description = Global.data.card.moss.apt.format([text1, text2, text3])
	super.refresh()
	
func attack() -> void:
	buff_value_sum = 0
	var temp = attack_component.atk
	attack_component.atk += moss.get_rune_count(card_owner) * rate / 100
	super.attack()
	attack_component.atk = temp
	moss.add_rune(card_owner, health_component.shield * rate / 100)
	shielded(buff_value_sum, self)

func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += attack_component.atk * rate / 100