extends Piece
class_name MossADC

var moss = preload("res://script/cards/moss/moss.gd").new()
var rate : int = 25
var buff_value : int = 1
var buff_value_sum : int = 0

var default_icon = preload("res://img/piece/standerd/dark_green.png")
var half_power_icon = preload("res://img/piece/standerd/dark_green_half_powered.png")
var empower_icon = preload("res://img/piece/standerd/dark_green_empowered.png")

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.adc
	description = Global.data.card.moss.adc.format([str(0), str(rate), str(buff_value)])

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
	var text = str(power * rate / 100)
	Global.set_font_color(text, Global.get_font_color(power * rate / 100, 0))
	description = Global.data.card.moss.adc.format([text, str(rate), str(buff_value)])
	super.refresh()
	
func attack() -> void:
	buff_value_sum = 0
	var temp = attack_component.atk
	attack_component.atk += moss.get_rune_count(card_owner) * rate / 100
	super.attack()
	attack_component.atk = temp
	moss.add_rune(card_owner, buff_value_sum)

func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += 1