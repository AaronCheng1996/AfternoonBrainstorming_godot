extends Node2D
class_name Piece

var location : Vector2i
var is_on_board : bool
var player : int

@export var health_component : HealthComponent
@export var attack_component : AttackComponent
@export var outfit_component : OutfitComponent
@export var score_component : ScoreComponent
@export var buff_component : BuffComponent

#棋子放置時
func on_piece_set() -> void:
	if buff_component:
		var stun_debuff = Stun.new()
		stun_debuff.name = "stun"
		stun_debuff.duration = 1
		buff_component.add_buff(stun_debuff)

#回合開始時
func on_turn_start(player_turn: int) -> void:
	pass

#回合結束時
func on_turn_end(player_turn: int) -> void:
	if player_turn != player:
		return
	tick()

#計算分數
func get_score() -> int:
	if not score_component:
		return 0
	if player == 0:
		return -score_component.score
	else:
		return score_component.score

#動作

func select_effect(is_selected: bool, display_control: bool = false) -> void:
	#預留：選取動畫
	if outfit_component:
		outfit_component.show_control_panel(is_selected and display_control)

func attack(target: Array) -> void:
	if attack_component:
		attack_component.attack(target)

func get_target_location(pieces: Array) -> Array:
	if attack_component:
		return attack_component.get_target_location(pieces)
	else:
		return []

#buff

#賦予buff
func add_buff(buff: Buff) -> void:
	if buff_component:
		buff_component.add_buff(buff)

#移除buff
func remove_buff(buff: Buff) -> void:
	if buff_component:
		buff_component.remove_buff(buff)

#經過一回合
func tick() -> void:
	if buff_component:
		buff_component.tick()

#清除buff
func clear_buffs() -> void:
	if buff_component:
		buff_component.clear_buffs()
