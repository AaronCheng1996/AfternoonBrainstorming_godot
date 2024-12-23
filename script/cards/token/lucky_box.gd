extends Piece
class_name LuckyBox

const Green = preload("res://script/cards/green/green.gd")
var green : Green

func _ready() -> void:
	green = Green.new()
	super._ready()

func _init() -> void:
	show_name = Global.data.card.token.token_name.lucky_box
	description = Global.data.card.token.token_description.lucky_box
	card_type = Global.CardType.TOKEN

func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	if has_node("HealthComponent"):
		#預留：動畫位置
		var is_killed = health_component.take_damaged(damage)
		if is_killed and not applyer == null:
			green.random_event(applyer)
		refresh()
		return is_killed
	else:
		return false

func die() -> void:
	#預留：動畫位置
	Global.board_pieces.erase(self)
	emit_signal("piece_die", self)
