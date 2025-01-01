extends Piece
class_name BlueHero

var blue: Blue = preload("res://script/cards/blue/blue.gd").new()
var beam_scene = preload("res://scenes/attack/beam_attack.tscn")
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
			var enemy = get_random_enemy()
			attack_component.hit(enemy)
			if not enemy == null:
				var beam = beam_scene.instantiate()
				var random_offset = Vector2(Global.rng.randi_range(-10, 10), Global.rng.randi_range(-10, 10))
				beam.start_position = Vector2(0, 0)
				beam.end_position = Vector2((enemy.location - location) * 80) + random_offset
				add_child(beam)
				await get_tree().create_timer(0.1).timeout
				beam.queue_free()
