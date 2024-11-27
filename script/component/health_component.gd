extends Node2D
class_name HealthComponent

signal death()
signal damaged()

#生命
@export var MAX_HEALTH := 10
var health : int
#護盾
@export var MAX_SHIELD := 0
var shield : int

func _ready() -> void:
	health = MAX_HEALTH
	shield = MAX_SHIELD

#承受傷害
func take_damaged(attack: int):
	emit_signal("damaged")
	#盾先承受，生命再承受
	if shield >= attack:
		shield -= attack
	else:
		shield = 0
		health -= attack - shield
	#若生命降為0，則死亡
	if health <= 0:
		emit_signal("death")
