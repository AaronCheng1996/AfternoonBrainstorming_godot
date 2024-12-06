extends Node2D
class_name ScoreComponent

#預設得分
@export var DEAFULT_SCORE : int = 1
var score : int

func _ready() -> void:
	score = DEAFULT_SCORE
