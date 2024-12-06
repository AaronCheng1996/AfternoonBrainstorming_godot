extends Node2D
class_name HealthComponent

signal on_heal(value: int)
signal on_over_heal(value: int)
signal on_shielded(value: int)
signal damage_taken(value: int)
signal death(piece: Piece)

#生命
@export var DEAFULT_MAX_HEALTH : int = 10
var max_health : int
var health : int
#護盾
@export var DEAFULT_SHIELD : int = 0
var shield : int

func _ready() -> void:
	max_health = DEAFULT_MAX_HEALTH
	health = max_health
	shield = DEAFULT_SHIELD

#補血
func heal(heal: int) -> int:
	emit_signal("on_heal", heal)
	var over_heal = health + heal - max_health
	if over_heal > 0:
		emit_signal("on_over_heal", over_heal)
		health = max_health
		shielded(over_heal / 2)
		return over_heal
	else:
		health += heal
		return 0

#獲得護盾
func shielded(value: int) -> void:
	emit_signal("on_shielded", value)
	shield += value

#承受傷害
func take_damaged(damage: int) -> bool:
	#預留動畫位置
	emit_signal("damage_taken", damage)
	#盾先承受，生命再承受
	if shield >= damage:
		shield -= damage
	else:
		health -= (damage - shield)
		shield = 0
	#若生命降為0，則死亡
	if health <= 0:
		#預留動畫位置
		emit_signal("death", get_parent())
		return true
	return false
