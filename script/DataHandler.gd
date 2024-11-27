extends Node

var assets := []
#棋子名稱
enum PieceNames {WHITE_ASS, WHITE_CUBE, WHITE_DIAMOND, WHITE_DLOZ, WHITE_HEX, WHITE_SPHERE, WHITE_TRAP, WHITE_TRI}
#格子狀態
enum slot_states {NONE, BLUE, RED}

func _ready() -> void:
	assets.append("res://img/piece/standerd/white_ass.png")
	assets.append("res://img/piece/standerd/white_cube.png")
	assets.append("res://img/piece/standerd/white_diamond.png")
	assets.append("res://img/piece/standerd/white_dloz.png")
	assets.append("res://img/piece/standerd/white_hex.png")
	assets.append("res://img/piece/standerd/white_sphere.png")
	assets.append("res://img/piece/standerd/white_trap.png")
	assets.append("res://img/piece/standerd/white_tri.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
