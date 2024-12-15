extends Control
class_name PieceDetail

signal piece_selected(piece: Piece)

@onready var lbl_piece_name: RichTextLabel = $lbl_piece_name
@onready var lbl_piece_description: RichTextLabel = $lbl_piece_description
@onready var piece_icon: Sprite2D = $piece_icon

@onready var highlight: ColorRect = $highlight

@onready var health_bar: ProgressBar = $HealthStates/health_bar
@onready var health: Label = $HealthStates/health
@onready var shield_icon: TextureRect = $HealthStates/shield_icon
@onready var shield: Label = $HealthStates/shield
@onready var shield_effect: ColorRect = $HealthStates/shield_effect

@onready var max_health_state: PieceState = $States/max_health_state
@onready var pattern_state: PieceState = $States/pattern_state
@onready var attack_state: PieceState = $States/attack_state

@onready var buff_icon_list: BuffIconList = $Buffs
@onready var shader: ColorRect = $shader

var piece_data: Piece
var lbl_name_size = 20
var lbl_description_size = 16
@export var show_highlight : bool = true

#顯示棋子細節
func show_piece_detail(piece: Piece) -> void:
	if not piece: #棋子不存在
		hide()
		return
	
	piece_data = piece
	show()
	#圖示
	if piece.outfit_component.icon:
		piece_icon.texture = piece.outfit_component.icon.texture
		piece_icon.frame = piece.outfit_component.icon.frame
	#名稱、敘述
	lbl_piece_name.text = Global.set_font_size(Global.set_font_center(piece.show_name), lbl_name_size)
	lbl_piece_description.text = Global.set_font_size(Global.set_font_center(piece.description), lbl_description_size)
	#最大生命、生命
	if piece.health_component:
		max_health_state.default_value = piece.health_component.DEAFULT_MAX_HEALTH
		max_health_state.value = piece.health_component.max_health
		max_health_state.refresh_value_text()
		#血條
		health_bar.max_value = piece.health_component.max_health
		health_bar.value = piece.health_component.health
		health.text = "{0} / {1}".format([str(piece.health_component.health), str(piece.health_component.max_health)])
		#護盾
		if piece.health_component.shield > 0:
			shield_icon.show()
			shield.show()
			shield_effect.show()
			shield.text = str(piece.health_component.shield)
		else:
			shield_icon.hide()
			shield.hide()
			shield_effect.hide()
	else:
		max_health_state.hide()
	#攻擊力、攻擊模式
	if piece.attack_component:
		attack_state.default_value = piece.attack_component.DEFAULT_ATK
		attack_state.value = piece.attack_component.atk
		attack_state.refresh_value_text()
		#補上pattern_state圖示
		match piece.attack_component.ATK_PATTERN:
			Global.PatternNames.CROSS:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/cross.png")
			Global.PatternNames.CROSS_LARGE:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/large_cross.png")
			Global.PatternNames.X:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/x.png")
			Global.PatternNames.X_LARGE:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/large_x.png")
			Global.PatternNames.NEARBY:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/nearby.png")
			Global.PatternNames.NEAREST:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/near.png")
			Global.PatternNames.FAREST:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/far.png")
			Global.PatternNames.ALL:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/all.png")
		pattern_state.refresh_value_text()
	else:
		attack_state.hide()
		pattern_state.hide()
	#Buff
	if piece.buff_component:
		buff_icon_list.show_buffs(piece.buff_component.active_buffs)

func show_shader():
	shader.show()

func hide_shader():
	shader.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", piece_data)

func _on_mouse_entered() -> void:
	if show_highlight:
		highlight.show()

func _on_mouse_exited() -> void:
	highlight.hide()
