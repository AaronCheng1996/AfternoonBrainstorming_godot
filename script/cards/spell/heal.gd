extends Spell
class_name Heal

var value : int = 8

func _init() -> void:
	show_name = Global.data.card.spell.spell_name.heal
	description = Global.data.card.spell.spell_description.heal.format([str(value)])

#取得可放置範圍
func get_valid_location() -> Array:
	var result := []
	for key in Global.board_dic.keys():
		if Global.board[key] is not int:
			result.append(Global.string_to_vector2i(key))
	return result

#效果
func effect(target: Vector2i) -> void:
	Global.board[str(target)].heal(value, self)
