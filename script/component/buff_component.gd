extends Node
class_name BuffComponent

signal on_buff_apply(buff: Buff)
signal on_buff_remove(buff: Buff)
var active_buffs: Array = []
var history_buffs: Array = []

@onready var buff_list: BuffIconList = $BuffList
@export var size : Vector2 = Vector2(66, 11)
@export var always_full_icon : bool = false

func _ready() -> void:
	buff_list.size = size

func show_buff() -> void:
	if active_buffs.size() < 4 or always_full_icon:
		buff_list.show_buffs(active_buffs)
	else:
		buff_list.show_mini_buffs(active_buffs)

#賦予buff
func add_buff(buff: Buff) -> void:
	active_buffs.append(buff)
	history_buffs.append(buff)
	buff.apply_buff(get_parent())
	emit_signal("on_buff_apply", buff)
	show_buff()
	
#移除buff
func remove_buff(buff: Buff) -> void:
	if buff in active_buffs:
		buff.remove_buff(get_parent())
		active_buffs.erase(buff)
		emit_signal("on_buff_remove", buff)
		show_buff()

#經過一回合
func tick() -> void:
	for buff: Buff in active_buffs:
		buff.tick(get_parent())
		buff.duration -= 1
		if buff.duration <= 0:
			remove_buff(buff)

#清除buff
func clear_buffs() -> void:
	for buff: Buff in active_buffs:
		buff.remove_buff(get_parent())
	active_buffs.clear()

#是否存在buff
func has_buff(name: String) -> bool:
	for buff: Buff in active_buffs:
		if buff.name == name:
			return true
	return false

func get_buff(name: String) -> Buff:
	for buff: Buff in active_buffs:
		if buff.name == name:
			return buff
	return null
