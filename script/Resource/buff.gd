extends Resource
class_name Buff

var name: String
var description: String
var duration: int = INF
var tag := []


func apply_buff(target) -> void:
	pass

func remove_buff(target) -> void:
	pass

func tick(target) -> void:
	pass
