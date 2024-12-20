extends Buff
class_name Move

func apply_buff(target) -> void:
	#可以移動
	if target.get_node_or_null("OutfitComponent"):
		target.outfit_component.show_move()

func remove_buff(target) -> void:
	#恢復不可移動狀態
	if target.get_node_or_null("OutfitComponent"):
		target.outfit_component.hide_move()
