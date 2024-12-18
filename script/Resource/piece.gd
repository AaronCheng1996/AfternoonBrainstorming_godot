extends Node2D
class_name Piece

var tag := []
var show_name : String = ""
var description : String = ""
var location : Vector2i
var is_on_board : bool
var piece_owner : Player

@export var health_component : HealthComponent
@export var attack_component : AttackComponent
@export var outfit_component : OutfitComponent
@export var score_component : ScoreComponent
@export var buff_component : BuffComponent

func _ready() -> void:
	refresh()

#回歸原廠設定
func renew() -> void:
	if buff_component:
		buff_component.clear_buffs()
	if health_component:
		health_component.health = health_component.DEAFULT_MAX_HEALTH
		health_component.shield = health_component.DEAFULT_SHIELD
		health_component.always_show = false
		health_component.health_display.hide()
	if attack_component:
		attack_component.atk = attack_component.DEFAULT_ATK
	if score_component:
		score_component.score = score_component.DEAFULT_SCORE
	if outfit_component:
		outfit_component.txt_value.hide()
	is_on_board = false
	refresh()

#region 觸發時機
#棋子放置時
func on_piece_set(pieces: Array) -> void:
	if buff_component:
		var stun_debuff = Stun.new()
		stun_debuff.name = Global.data.buff.sleep.name
		stun_debuff.description = Global.data.buff.sleep.description
		stun_debuff.duration = 1
		stun_debuff.icon_path = Global.buff_icon.sleep
		stun_debuff.tag.append(Global.BuffTag.DEBUFF)
		add_buff(stun_debuff)
	refresh()

#回合開始時
func on_turn_start(current_turn: int, pieces: Array) -> void:
	pass

#回合結束時
func on_turn_end(current_turn: int, pieces: Array) -> void:
	if current_turn != piece_owner.id:
		return
	tick()

#計算分數
func get_score(current_turn: int) -> int:
	if current_turn != piece_owner.id:
		return 0
	if not score_component:
		return 0
	if piece_owner.id == 0:
		return -score_component.score
	else:
		return score_component.score
#endregion

#region 動作
#選取特效
func show_select_effect() -> void:
	#預留：選取動畫
	if outfit_component:
		outfit_component.show_control_panel()
func hide_select_effect() -> void:
	#預留：選取動畫
	if outfit_component:
		outfit_component.hide_control_panel()
#攻擊
func attack(pieces: Array) -> void:
	if attack_component:
		var targets = pieces.filter(filter_opponent_piece).filter(filter_piece_on_board)
		attack_component.attack(targets)
#取得攻擊範圍
func get_target_location(pieces: Array) -> Array:
	if attack_component:
		pieces = pieces.filter(filter_opponent_piece).filter(filter_piece_on_board)
		return attack_component.get_target_location(pieces)
	else:
		return []
#補血
func heal(heal: int, applyer) -> int:
	if health_component:
		var is_over_healed = health_component.heal(heal)
		refresh()
		return is_over_healed
	else:
		return 0
#獲得護盾
func shielded(value: int, applyer) -> void:
	if health_component:
		health_component.shielded(value)
		refresh()
#承受傷害
func take_damaged(damage: int, applyer) -> bool:
	if health_component:
		var is_killed = health_component.take_damaged(damage)
		refresh()
		return is_killed
	else:
		return false
#更新顯示數值
func refresh() -> void:
	if not outfit_component:
		return
	if attack_component:
		outfit_component.refresh_value(attack_component.atk, attack_component.DEFAULT_ATK)
#endregion

#region buff
#賦予buff
func add_buff(buff: Buff) -> void:
	if buff_component:
		buff_component.add_buff(buff)
		refresh()
#移除buff
func remove_buff(buff: Buff) -> void:
	if buff_component:
		buff_component.remove_buff(buff)
		refresh()
#經過一回合
func tick() -> void:
	if buff_component:
		buff_component.tick()
		refresh()
#清除buff
func clear_buffs() -> void:
	if buff_component:
		buff_component.clear_buffs()
		refresh()

#endregion

#region 過濾
#過濾出場上棋子
func filter_piece_on_board(piece: Piece):
	return piece.is_on_board
#過濾出除自己外的友方
func filter_ally_piece(piece: Piece):
	return piece.piece_owner.id == piece_owner.id and piece.location != location
#過濾出敵方
func filter_opponent_piece(piece: Piece):
	return piece.piece_owner.id != piece_owner.id
#endregion
