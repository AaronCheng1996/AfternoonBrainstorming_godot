extends Node2D
class_name Piece

var tag := []
var show_name : String = ""
var description : String = ""
var location : Vector2i
var is_on_board : bool
var player : int

@export var health_component : HealthComponent
@export var attack_component : AttackComponent
@export var outfit_component : OutfitComponent
@export var score_component : ScoreComponent
@export var buff_component : BuffComponent
@onready var icon = $Icon

#棋子放置時
func on_piece_set() -> void:
	if buff_component:
		var stun_debuff = Stun.new()
		stun_debuff.name = "Sleep"
		stun_debuff.description = "This piece is sleeping.\n Can't attack and gain score"
		stun_debuff.duration = 1
		stun_debuff.tag.append("debuff")
		buff_component.add_buff(stun_debuff)
	refresh()

#回合開始時
func on_turn_start(player_turn: int) -> void:
	pass

#回合結束時
func on_turn_end(player_turn: int) -> void:
	if player_turn != player:
		return
	tick()

#計算分數
func get_score(player_turn: int) -> int:
	if player_turn != player:
		return 0
	if not score_component:
		return 0
	if player == 0:
		return -score_component.score
	else:
		return score_component.score

#動作
#過濾出除自己外的友方
func filter_ally_piece(piece: Piece):
	return piece.player == player and piece.location != location
#過濾出敵方
func filter_opponent_piece(piece: Piece):
	return piece.player != player
#選取特效
func select_effect(is_selected: bool, display_control: bool = false) -> void:
	#預留：選取動畫
	if outfit_component:
		outfit_component.show_control_panel(is_selected and display_control)
#攻擊
func attack(targets: Array) -> void:
	if attack_component:
		targets = targets.filter(filter_opponent_piece)
		attack_component.attack(targets)
#取得攻擊範圍
func get_target_location(pieces: Array) -> Array:
	if attack_component:
		pieces = pieces.filter(filter_opponent_piece)
		return attack_component.get_target_location(pieces)
	else:
		return []
#補血
func heal(heal: int) -> int:
	if health_component:
		var is_over_healed = health_component.heal(heal)
		refresh()
		return is_over_healed
	else:
		return 0
#獲得護盾
func shielded(value: int) -> void:
	if health_component:
		health_component.shielded(value)
		refresh()
#承受傷害
func take_damaged(damage: int) -> bool:
	if health_component:
		var is_killed = health_component.take_damaged(damage)
		refresh()
		return is_killed
	else:
		return false

#buff
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

#更新顯示數值
func refresh() -> void:
	if not outfit_component:
		return
	if attack_component:
		outfit_component.refresh_value(attack_component.atk, attack_component.DEFAULT_ATK)
