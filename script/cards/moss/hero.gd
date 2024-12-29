extends Piece
class_name MossHero

var moss = preload("res://script/cards/moss/moss.gd").new()
var value : int = 3

func _init() -> void:
	show_name = Global.data.card.moss.hero.show_name
	description = Global.data.card.moss.hero.description.format([str(value), str(0)])
	hint = Global.data.card.moss.hero.hint
	piece_type = Global.PieceType.HERO

func refresh() -> void:
	#更改圖示
	var power = moss.get_rune_count(card_owner)
	moss.update_icon(self)
	#更改說明
	var text = str(power / 10)
	text = Global.set_font_color(text, Global.get_font_color(power / 10, 0))
	description = Global.data.card.moss.hero.description.format([str(value), str(text)])
	super.refresh()

func on_piece_set() -> void:
	outfit_component.hide_attack()
	super.on_piece_set()

#回合開始時
func on_turn_start(current_turn: int) -> void:
	if not is_on_board:
		return
	if is_dead:
		return
	if current_turn == card_owner.id:
		moss.add_rune(card_owner, value)

#計算分數
func get_score(current_turn: int) -> int:
	var score : int = score_component.score
	if current_turn != card_owner.id:
		return 0
	
	if not buff_component.has_buff(Global.data.buff.sleep.name) and not buff_component.has_buff(Global.data.buff.stun.name):
		score += moss.get_rune_count(card_owner) / 10
	
	if card_owner.id == 0:
		return -score
	else:
		return score
