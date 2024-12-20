extends Buff
class_name DeathDoor

func tick(target: Piece) -> void:
	#死亡
	target.die()
