extends Spell
class_name Cubes

const CUBE = preload("res://scenes/cards/spell/cube.tscn")

var value : int = 2

func _init() -> void:
	show_name = Global.data.card.spell.spell_name.cubes
	description = Global.data.card.spell.spell_description.cubes.format([str(value)])

#效果
func effect(target: Vector2i) -> void:
	for i in range(value):
		var cube = CUBE.instantiate()
		cube.card_owner = card_owner
		cube.is_on_board = false
		card_owner.get_card(cube)
