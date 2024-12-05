extends Node2D

signal piece_death(piece)

@onready var attack_component = $AttackComponent
@onready var health_component = $HealthComponent
@onready var outfit_component = $OutfitComponent

var location : Vector2i
var is_on_board : bool
var player : int

func _ready() -> void:
	health_component.damaged.connect(_on_damaged)
	health_component.death.connect(_on_death)

#受到傷害時
func _on_damaged() -> void:
	#預留：受傷動畫
	pass

#死亡時
func _on_death() -> void:
	#預留：死亡動畫
	emit_signal("piece_death", self)
