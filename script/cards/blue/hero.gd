extends Piece
class_name BlueHero

var blue: Blue = preload("res://script/cards/blue/blue.gd").new()
var buff_value : int = 1
var hit_count : int = 3

func _init() -> void:
	show_name = Global.data.card.blue.hero.show_name
	description = Global.data.card.blue.hero.description.format([str(hit_count)])
	hint = Global.data.card.blue.hero.hint
	piece_type = Global.PieceType.HERO

func on_piece_set() -> void:
	outfit_component.hide_attack()
	super.on_piece_set()

#回合結束時
func on_turn_end(current_turn: int) -> void:
	if current_turn == card_owner.id:
		blue.add_blue_charge(card_owner, buff_value)
	super.on_turn_end(current_turn)

func trigger_effect(value: int) -> void:
	if is_on_board:
		for i in range(hit_count):
			attack_component.hit(get_random_enemy())