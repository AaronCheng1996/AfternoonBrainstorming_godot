extends Node2D
class_name Player

var id : int
var deck := []
var deck_piece_type := {}
var hand := []
var grave := []
var attack_count : int = 0
@export var buff_component : BuffComponent

func _ready() -> void:
	hand.resize(Global.hand_size)
	hand.fill(0)
