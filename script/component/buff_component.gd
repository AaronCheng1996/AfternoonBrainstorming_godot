extends Node
class_name BuffComponent

signal on_buff_apply(buff: Buff)
signal on_buff_remove(buff: Buff)
var active_buffs: Array = []
var history_buffs: Array = []

#賦予buff
func add_buff(buff: Buff) -> void:
	active_buffs.append(buff)
	history_buffs.append(buff)
	buff.apply_buff(get_parent())
	emit_signal("on_buff_apply", buff)

#移除buff
func remove_buff(buff: Buff) -> void:
	if buff in active_buffs:
		buff.remove_buff(get_parent())
		active_buffs.erase(buff)
		emit_signal("on_buff_remove", buff)

#經過一回合
func tick() -> void:
	for buff in active_buffs:
		buff.tick(get_parent())
		buff.duration -= 1
		if buff.duration <= 0:
			remove_buff(buff)

#清除buff
func clear_buffs() -> void:
	for buff in active_buffs:
		buff.remove_buff(get_parent())
	active_buffs.clear()
