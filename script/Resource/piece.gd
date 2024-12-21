extends Card
class_name Piece

signal auto_attack(piece: Piece)
signal piece_die(piece: Piece)

var card_type : Global.CardType = Global.CardType.PIECE
@export var health_component : HealthComponent
@export var attack_component : AttackComponent
@export var outfit_component : OutfitComponent
@export var score_component : ScoreComponent
@export var buff_component : BuffComponent
var is_dead: bool = false

func _ready() -> void:
	if has_node("HealthComponent"):
		health_component.death.connect(die)
	refresh()

#回歸原廠設定
func renew() -> void:
	if has_node("BuffComponent"):
		buff_component.clear_buffs()
	if has_node("HealthComponent"):
		health_component.health = health_component.DEAFULT_MAX_HEALTH
		health_component.shield = health_component.DEAFULT_SHIELD
		health_component.always_show = false
		health_component.health_display.hide()
	if has_node("AttackComponent"):
		attack_component.atk = attack_component.DEFAULT_ATK
	if has_node("ScoreComponent"):
		score_component.score = score_component.DEAFULT_SCORE
	if has_node("OutfitComponent"):
		outfit_component.txt_value.hide()
		outfit_component.player_effect.hide()
	is_on_board = false
	is_dead = false
	refresh()

#region 觸發時機
#棋子放置時
func on_piece_set() -> void:
	if has_node("BuffComponent"):
		var stun_debuff = Global.get_stun_debuff()
		stun_debuff.show_name = Global.data.buff.sleep.name
		stun_debuff.description = Global.data.buff.sleep.description
		stun_debuff.icon_path = Global.buff_icon.sleep
		add_buff(stun_debuff)
	refresh()

#回合開始時
func on_turn_start(current_turn: int) -> void:
	pass

#回合結束時
func on_turn_end(current_turn: int) -> void:
	if not card_owner == null:
		if current_turn != card_owner.id:
			return
	tick()

#移動後
func after_move() -> void:
	pass

#計算分數
func get_score(current_turn: int) -> int:
	if card_owner == null:
		return 0
	if current_turn != card_owner.id:
		return 0
	if not has_node("ScoreComponent"):
		return 0
	if card_owner.id == 0:
		return -score_component.score
	else:
		return score_component.score
#endregion

#region 動作
#選取特效
func show_select_effect() -> void:
	#預留：選取動畫
	if has_node("OutfitComponent") and is_on_board:
		outfit_component.show_control_panel()
func hide_select_effect() -> void:
	#預留：選取動畫
	if has_node("OutfitComponent"):
		outfit_component.hide_control_panel()
#攻擊
func attack() -> void:
	if has_node("AttackComponent"):
		var targets = []
		for slot in Global.board_dic.values():
			if slot is not int:
				targets.append(slot)
		attack_component.attack(targets.filter(filter_opponent_piece))
#取得攻擊範圍
func get_target_location() -> Array:
	if has_node("AttackComponent"):
		var targets = []
		for slot in Global.board_dic.values():
			if slot is not int:
				targets.append(slot)
		return attack_component.get_target_location(targets.filter(filter_opponent_piece))
	else:
		return []
#取得移動範圍
func get_move_location() -> Array:
	var result = []
	for key in Global.board_dic.keys():
		if Global.board_dic[key] is not int: #該格子有其他棋子
			continue
		var board_location: Vector2i = Global.string_to_vector2i(key)
		if abs(board_location.x - location.x) <= 1 and abs(board_location.y - location.y) <= 1: #九宮格範圍
			result.append(board_location)
	return result
#補血
func heal(heal: int, applyer) -> int:
	if has_node("HealthComponent"):
		var is_over_healed = health_component.heal(heal)
		refresh()
		return is_over_healed
	else:
		return 0
#獲得護盾
func shielded(value: int, applyer) -> void:
	if has_node("HealthComponent"):
		health_component.shielded(value)
		refresh()
#被鎖定
func targeted() -> bool:
	return true
#承受傷害
func take_damaged(damage: int, applyer) -> bool:
	if damage <= 0:
		return false
	if has_node("HealthComponent"):
		#預留：動畫位置
		var is_killed = health_component.take_damaged(damage)
		refresh()
		return is_killed
	else:
		return false
#死亡
func die() -> void:
	#預留：動畫位置
	renew()
	card_owner.on_board.pop_at(card_owner.on_board.find(self))
	card_owner.grave.append(self)
	emit_signal("piece_die", self)
#更新顯示數值
func refresh() -> void:
	if not has_node("OutfitComponent"):
		return
	if has_node("AttackComponent"):
		outfit_component.refresh_value(attack_component.atk, attack_component.DEFAULT_ATK)
#endregion

#region buff
#賦予buff
func add_buff(buff: Buff) -> void:
	if has_node("BuffComponent"):
		buff_component.add_buff(buff)
		refresh()
#移除buff
func remove_buff(buff: Buff) -> void:
	if has_node("BuffComponent"):
		buff_component.remove_buff(buff)
		refresh()
#經過一回合
func tick() -> void:
	if has_node("BuffComponent"):
		buff_component.tick()
		refresh()
#清除buff
func clear_buffs() -> void:
	if has_node("BuffComponent"):
		buff_component.clear_buffs()
		refresh()

#endregion

#region 過濾
#過濾出除自己外的友方
func filter_ally_piece(piece: Piece):
	if piece.card_owner == null:
		return false
	return piece.card_owner.id == card_owner.id and piece.location != location
#過濾出敵方
func filter_opponent_piece(piece: Piece):
	if piece.card_owner == null:
		return true
	return piece.card_owner.id != card_owner.id
#endregion
