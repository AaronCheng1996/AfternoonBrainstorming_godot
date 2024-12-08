extends Control
class_name PieceDetail

@onready var lbl_piece_name = $lbl_piece_name
@onready var piece_icon = $piece_icon
@onready var lbl_piece_description = $lbl_piece_description

@onready var max_health_state = $States/max_health_state
@onready var attack_state = $States/attack_state
@onready var pattern_state = $States/pattern_state
enum PatternNames {CROSS, CROSS_LARGE, X, X_LARGE, NEARBY, NEAREST, FAREST}

#顯示棋子細節
func show_piece_detail(piece: Piece) -> void:
	if not piece: #棋子不存在
		visible = false
		return
	
	visible = true
	#圖示
	if piece.icon:
		piece_icon.texture = piece.icon.texture
	#名稱、敘述
	lbl_piece_name.text = Global.set_font_size(Global.set_font_center(piece.show_name), str(20))
	lbl_piece_description.text = Global.set_font_size(Global.set_font_center(piece.description), str(16))
	#最大生命
	if piece.health_component:
		max_health_state.default_value = piece.health_component.DEAFULT_MAX_HEALTH
		max_health_state.value = piece.health_component.max_health
		max_health_state.refresh_value_text()
	else:
		max_health_state.visible = false
	#攻擊力、攻擊模式
	if piece.attack_component:
		attack_state.default_value = piece.attack_component.DEFAULT_ATK
		attack_state.value = piece.attack_component.atk
		attack_state.refresh_value_text()
		#補上pattern_state圖示
		match piece.attack_component.ATK_PATTERN:
			PatternNames.CROSS:
				pattern_state.txt_icon_texture = load("res://img/UI/cross.png")
			PatternNames.CROSS_LARGE:
				pattern_state.txt_icon_texture = load("res://img/UI/large_cross.png")
			PatternNames.X:
				pattern_state.txt_icon_texture = load("res://img/UI/x.png")
			PatternNames.X_LARGE:
				pattern_state.txt_icon_texture = load("res://img/UI/large_x.png")
			PatternNames.NEARBY:
				pattern_state.txt_icon_texture = load("res://img/UI/nearby.png")
			PatternNames.NEAREST:
				pattern_state.txt_icon_texture = load("res://img/UI/near.png")
			PatternNames.FAREST:
				pattern_state.txt_icon_texture = load("res://img/UI/far.png")
		pattern_state.refresh_value_text()
	else:
		attack_state.visible = false
		pattern_state.visible = false
