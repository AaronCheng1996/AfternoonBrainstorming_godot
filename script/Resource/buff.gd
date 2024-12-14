extends Resource
class_name Buff

var name: String
var description: String
var duration: int = INF
var icon_path := {}
var tag := []
var show_value : bool = false
var value: int = 0

func apply_buff(target) -> void:
	pass

func remove_buff(target) -> void:
	pass

func tick(target) -> void:
	pass
