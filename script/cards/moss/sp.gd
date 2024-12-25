extends Piece
class_name MossSP

var moss = preload("res://script/cards/moss/moss.gd").new()

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.sp
	description = Global.data.card.moss.sp

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

#加倍
func on_piece_set() -> void:
	moss.add_rune(card_owner, moss.get_rune_count(card_owner) / 2)
	super.on_piece_set()

#減半
func die() -> void:
	moss.add_rune(card_owner, -moss.get_rune_count(card_owner) / 4)
	super.die()
