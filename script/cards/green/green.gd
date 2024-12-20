extends Node
class_name Green

"""
#好運效果：
護甲+4
自身攻擊乘2
攻擊一次(依該單位攻擊而異)
附加移動中效果
在該幸運方塊上下左右放置一格幸運方塊(假若是綠色法師效果則此項為無效果)

#壞運效果：
破盾
獲得暈眩效果
血量除2
攻擊除2
要是血量高於等於2則血量減2，否則無(不會觸發單位被攻擊或擊殺效果)

#Note1：只有有效觸發的效果會進入觸發的佇列
#Note2：觸發好運/壞運預設會造成幸運值+1/-1
"""
#檢查對象幸運值
func check_luck(target: Player) -> int:
	return 0

#確認是否觸發效果
func is_trigger(target: Piece) -> bool:
	return true

#好運效果
func lucky_event(target: Piece) -> void:
	pass

#壞運效果
func unlucky_event(target: Piece) -> void:
	pass
