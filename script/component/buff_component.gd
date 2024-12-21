extends Node
class_name BuffComponent

signal on_buff_apply(buff: Buff)
signal on_buff_remove(buff: Buff)
var active_buffs: Array = []

@onready var buff_list: BuffIconList = $BuffList
@export var size : Vector2 = Vector2(66, 11)
@export var always_full_icon : bool = false
@export var icon_count_limit : int = 4
@export var mini_count_limit : int = 12

func _ready() -> void:
	buff_list.size = size
	buff_list.icon_count_limit = icon_count_limit
	buff_list.mini_count_limit = mini_count_limit

func show_buff() -> void:
	if active_buffs.size() < icon_count_limit or always_full_icon:
		buff_list.show_buffs(active_buffs)
	else:
		buff_list.show_mini_buffs(active_buffs)

#賦予buff
func add_buff(buff: Buff) -> void:
	active_buffs.append(buff)
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
	var n : int = active_buffs.size()
	for i in range(n):
		if active_buffs.size() == 0: #計算瀕死後會清空，在此過濾以防bug
			break
		var buff: Buff = active_buffs[n - i - 1]
		buff.tick(get_parent())
		buff.duration -= 1
		if buff.duration <= 0:
			remove_buff(buff)

#清除buff
func clear_buffs() -> void:
	for buff: Buff in active_buffs:
		buff.remove_buff(get_parent())
	active_buffs.clear()
	show_buff()

#是否存在buff
func has_buff(name: String) -> bool:
	for buff: Buff in active_buffs:
		if buff.show_name == name:
			return true
	return false

func get_buff(name: String) -> Buff:
	for buff: Buff in active_buffs:
		if buff.show_name == name:
			return buff
	return null
