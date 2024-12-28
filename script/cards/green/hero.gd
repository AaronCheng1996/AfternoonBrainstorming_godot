extends Piece
class_name GreenHero

var green: Green = preload("res://script/cards/green/green.gd").new()
var divided: int = 10
enum TriggerEvent { VICTORY, DRAW, LUCKY_EVENT, FIRST_STRIKE, NONE }

func _init() -> void:
	show_name = Global.data.card.green.hero.show_name
	description = Global.data.card.green.hero.description
	hint = Global.data.card.green.hero.hint
	piece_type = Global.PieceType.HERO

func on_piece_set() -> void:
	health_component.max_health = get_lucky_random_number(green.check_luck(card_owner) / divided)
	health_component.health = health_component.max_health
	attack_component.atk = get_lucky_random_number(green.check_luck(card_owner) / divided)
	attack_component.ATK_PATTERN = Global.rng.randi_range(0, Global.PatternNames.size() - 1)
	#隨機事件
	var trigger_event: TriggerEvent = Global.rng.randi_range(0, TriggerEvent.size() - 1)
	match trigger_event:
		TriggerEvent.VICTORY:
			if green.check_luck(card_owner) == 200 and green.luck_is_trigger(card_owner, 8):
				print("觸發特殊勝利")
				card_owner.win()
			else:
				print("好像發生了什麼?")
		TriggerEvent.DRAW:
			print("觸發抽牌")
			card_owner.draw_card()
		TriggerEvent.LUCKY_EVENT:
			print("觸發幸運事件")
			green.lucky_event(self)
		TriggerEvent.NONE:
			print("什麼都沒發生")

	if not trigger_event == TriggerEvent.FIRST_STRIKE:
		#睡眠
		var stun_debuff = Global.get_stun_debuff()
		stun_debuff.show_name = Global.data.buff.sleep.name
		stun_debuff.description = Global.data.buff.sleep.description
		stun_debuff.icon_path = Global.buff_icon.sleep
		add_buff(stun_debuff)
	else:
		print("觸發先攻")
	
	refresh()

func get_lucky_random_number(n: int) -> int:
	var num = Global.rng.randi_range(1, n)
	var num2 = Global.rng.randi_range(1, n)
	if num2 > num:
		num = num2
	return num
