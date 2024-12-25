extends Piece
class_name MossAss

var moss = preload("res://script/cards/moss/moss.gd").new()
var buff_value : int = 4
	
func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.ass
	description = Global.data.card.moss.ass.format([str(buff_value)])

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

#棋子放置時
func on_piece_set() -> void:
	refresh()
	pass

func _on_attack_component_on_kill(target: Piece) -> void:
	moss.add_rune(card_owner, buff_value)
