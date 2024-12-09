extends Node2D
class_name HealthComponent

signal on_heal(value: int)
signal on_over_heal(value: int)
signal on_shielded(value: int)
signal damage_taken(value: int)
signal death(piece: Piece)

@onready var health_display: Control = $health_display
@onready var hurtbar: ProgressBar = $health_display/hurtbar
@onready var healthbar: ProgressBar = $health_display/healthbar
@onready var shield_effect: ColorRect = $health_display/shield_effect
@onready var timer: Timer = $health_display/Timer

#生命
@export var DEAFULT_MAX_HEALTH : int = 10
var max_health : int
var health : int
#護盾
@export var DEAFULT_SHIELD : int = 0
var shield : int

func _ready() -> void:
	health_display.visible = false
	max_health = DEAFULT_MAX_HEALTH
	health = max_health
	shield = DEAFULT_SHIELD
	hurtbar.max_value = max_health
	hurtbar.value = health
	healthbar.max_value = max_health
	healthbar.value = health

func _process(delta: float) -> void:
	#血條動畫
	if healthbar.max_value != max_health:
		healthbar.max_value = max_health
	if healthbar.value != health:
		healthbar.value = health
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(hurtbar, "value", healthbar.value, 0.3)
	#顯示護盾
	if shield > 0:
		shield_effect.visible = true
	else:
		shield_effect.visible = false
	
#補血
func heal(heal: int) -> int:
	var over_heal = health + heal - max_health
	if over_heal > 0:
		health = max_health
		emit_signal("on_over_heal", over_heal)
		shielded(over_heal / 2)
		return over_heal
	else:
		health += heal
		return 0
	emit_signal("on_heal", heal)

#獲得護盾
func shielded(value: int) -> void:
	shield += value
	emit_signal("on_shielded", value)

#承受傷害
func take_damaged(damage: int) -> bool:
	health_display.visible = true
	timer.start()
	#盾先承受，生命再承受
	if shield >= damage:
		shield -= damage
	else:
		health -= (damage - shield)
		shield = 0
	emit_signal("damage_taken", damage)
	#若生命降為0，則死亡
	if health <= 0:
		#預留動畫位置
		emit_signal("death", get_parent())
		return true
	return false

#血條顯示時間長
func _on_timer_timeout() -> void:
	health_display.visible = false
