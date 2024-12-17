extends Buff
class_name DeathDoor

func tick(target: Piece) -> void:
	#死亡
	target.health_component._on_timer_timeout()
