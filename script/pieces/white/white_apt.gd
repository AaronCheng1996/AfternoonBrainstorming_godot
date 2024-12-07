extends Piece
class_name WhiteAPT

func _init() -> void:
	show_name = "白色六邊形"
	description = "[b]攻擊後[/b]：為自己及最近友方\n附加 2 點護盾"

func _process(delta: float) -> void:
	if attack_component:
		description = "[b]攻擊後[/b]：為自己及最近友方\n附加 {0} 點護盾".format([attack_component.atk])

#攻擊改為最近友方附加兩點護盾
func attack(targets: Array) -> void:
	if attack_component:
		#給友方盾
		var allys = targets.filter(filter_ally_piece)
		allys = attack_component.find_target(location, allys, true)
		if allys.size() == 0:
			return
		var random_index = randi() % allys.size()
		allys[random_index].shielded(attack_component.atk)
		#敵方
		var enemys = targets.filter(filter_opponent_piece)
		attack_component.attack(enemys)

#自己附加兩點護盾
func _on_attack_component_start_attack(piece: Piece) -> void:
	if health_component:
		health_component.shielded(attack_component.atk)
