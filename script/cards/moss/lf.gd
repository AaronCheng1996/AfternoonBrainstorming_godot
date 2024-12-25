extends Piece
class_name MossLF

var moss = preload("res://script/cards/moss/moss.gd").new()
var rate : int = 25
var buff_value : int = 2
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.lf
	description = Global.data.card.moss.lf.format([str(0), str(rate), str(buff_value)])

var default_icon = preload("res://img/piece/standerd/dark_green.png")
var half_power_icon = preload("res://img/piece/standerd/dark_green_half_powered.png")
var empower_icon = preload("res://img/piece/standerd/dark_green_empowered.png")

func refresh() -> void:
	#更改圖示
	var power = moss.get_rune_count(card_owner)
	if power < 20 and outfit_component.icon.texture != default_icon:
		outfit_component.icon.texture = default_icon
	if power >= 20 and power < 50 and outfit_component.icon.texture != half_power_icon:
		outfit_component.icon.texture = half_power_icon
	if power >= 50 and outfit_component.icon.texture != empower_icon:
		outfit_component.icon.texture = empower_icon
	var text = str(moss.get_rune_count(card_owner) * rate / 100)
	Global.set_font_color(text, Global.get_font_color(moss.get_rune_count(card_owner) * rate / 100, 0))
	description = Global.data.card.moss.lf.format([text, str(rate), str(buff_value)])
	super.refresh()

func on_piece_set() -> void:
	var temp = attack_component.atk
	attack_component.atk = moss.get_rune_count(card_owner) * rate / 100
	attack()
	attack_component.atk = temp
	super.on_piece_set()

func attack() -> void:
	buff_value_sum = 0
	super.attack()
	moss.add_rune(card_owner, buff_value_sum)

func _on_attack_component_on_kill(target: Piece) -> void:
	buff_value_sum += buff_value
