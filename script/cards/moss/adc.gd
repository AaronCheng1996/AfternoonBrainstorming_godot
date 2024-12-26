extends Piece
class_name MossADC

var moss = preload("res://script/cards/moss/moss.gd").new()
var rate : int = 25

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.adc
	description = Global.data.card.moss.adc.format([str(0), str(rate)])

func refresh() -> void:
	#更改圖示
	var power = moss.get_rune_count(card_owner)
	moss.update_icon(self)
	#更改說明
	var text = str(power * rate / 100)
	Global.set_font_color(text, Global.get_font_color(power * rate / 100, 0))
	description = Global.data.card.moss.adc.format([text, str(rate)])
	super.refresh()
	
func attack() -> void:
	if has_node("AttackComponent"):
		attack_component.attack(Global.board_pieces.filter(filter_opponent_piece), moss.get_rune_count(card_owner) * rate / 100)
	refresh()
