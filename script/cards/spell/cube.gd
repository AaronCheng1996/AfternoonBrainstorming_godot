extends Spell
class_name Cube

var attack : int = 0
var health : int = 4
const CUBE_TOKEN = preload("res://scenes/cards/spell/cube_token.tscn")

func _init() -> void:
	show_name = Global.data.card.spell.spell_name.cube
	description = Global.data.card.spell.spell_description.cube.format([str(attack), str(health)])

#效果
func effect(board: Dictionary, target: Vector2i) -> void:
	var cube = CUBE_TOKEN.instantiate()
	cube.card_owner = null
	emit_signal("add_piece_to_board", cube, target)

#施放完
func used() -> void:
	get_parent().remove_child(self)
	card_owner.hand.pop_at(card_owner.hand.find(self))
	emit_signal("leave_hand", card_owner)
