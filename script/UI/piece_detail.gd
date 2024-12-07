extends Control
class_name PieceDetail

@onready var lbl_piece_name = $lbl_piece_name
@onready var piece_icon = $piece_icon
@onready var lbl_piece_description = $lbl_piece_description

@onready var max_health_state = $max_health_state
@onready var score_state = $score_state
@onready var attack_state = $attack_state
@onready var pattern_state = $pattern_state

#顯示棋子細節
func show_piece_detail(piece: Piece) -> void:
	if piece:
		visible = true
		#圖示
		if piece.icon:
			piece_icon.texture = piece.icon.texture
		#名稱、敘述
		lbl_piece_name.text = Global.set_font_size(Global.set_font_center(piece.show_name), str(20))
		lbl_piece_description.text = Global.set_font_size(Global.set_font_center(piece.description), str(16))
		#最大生命、得分、攻擊力、攻擊模式
		if piece.health_component:
			max_health_state.default_value = piece.health_component.DEAFULT_MAX_HEALTH
			max_health_state.value = piece.health_component.max_health
			max_health_state.refresh_value_text()
		else:
			max_health_state.visible = false
		if piece.score_component:
			score_state.default_value = piece.score_component.DEAFULT_SCORE
			score_state.value = piece.score_component.score
			score_state.refresh_value_text()
		else:
			score_state.visible = false
		if piece.attack_component:
			attack_state.default_value = piece.attack_component.DEFAULT_ATK
			attack_state.value = piece.attack_component.atk
			pattern_state.icon_mode = true
			#補上pattern_state圖示
			attack_state.refresh_value_text()
			pattern_state.refresh_value_text()
		else:
			attack_state.visible = false
			pattern_state.visible = false
	else:
		visible = false
