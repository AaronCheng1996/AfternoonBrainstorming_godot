extends Piece
class_name MossHF

var moss = preload("res://script/cards/moss/moss.gd").new()
var cost_value : int = 2
var buff_value : int = 2
var heal_value : int = 1
var total_heal : int = 0

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.hf
	description = Global.data.card.moss.hf.format([str(cost_value), str(buff_value), str(heal_value)])

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

func on_turn_start(player_turn) -> void:
	if player_turn == card_owner.id:
		take_damaged(cost_value, self)
		moss.add_rune(card_owner, buff_value)
	super.on_turn_start(player_turn)

func attack() -> void:
	total_heal = 0
	super.attack()
	heal(total_heal, self)

func _on_attack_component_on_hit(target: Piece) -> void:
	total_heal += heal_value