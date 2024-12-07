extends Node2D
class_name OutfitComponent

signal piece_selected(piece: Piece)
signal piece_attack(piece: Piece)
signal mouse_in_attack(piece: Piece)
signal mouse_out_attack(piece: Piece)
signal mouse_in_icon(piece: Piece)
signal mouse_out_icon(piece: Piece)

@onready var player_effect = $player_effect
@onready var txt_value = $txt_value
@onready var control_panel = $ControlPanel
@onready var move_button = $ControlPanel/btn_move
@onready var attack_button = $ControlPanel/btn_attack

@export var ICON : TextureRect

func _ready() -> void:
	#非選定狀態時隱藏
	if control_panel:
		control_panel.visible = false
	#圖示
	if ICON:
		ICON.gui_input.connect(_on_icon_gui_input)
		ICON.mouse_entered.connect(_on_icon_mouse_entered)
		ICON.mouse_exited.connect(_on_icon_mouse_exited)
	#移動鍵
	enable_move(false)

#套用玩家特效
func set_player_effect(player: int) -> void:
	if player == 0:
		player_effect.texture = load("res://img/piece/player/red_filter.png")
	if player == 1:
		player_effect.texture = load("res://img/piece/player/blue_filter.png")

#被選取時
func show_control_panel(show: bool) -> void:
	if control_panel:
		control_panel.visible = show

#無效攻擊
func enable_attack(enable) -> void:
	if attack_button:
		attack_button.disabled = !enable

#無效移動
func enable_move(enable) -> void:
	if move_button:
		move_button.disabled = !enable

#圖示互動
func _on_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", get_parent())

func _on_icon_mouse_entered() -> void:
	emit_signal("mouse_in_icon", get_parent())

func _on_icon_mouse_exited() -> void:
	emit_signal("mouse_out_icon", get_parent())

#攻擊鍵互動
func _on_btn_attack_pressed() -> void:
	emit_signal("piece_attack", get_parent())

func _on_btn_attack_mouse_entered() -> void:
	emit_signal("mouse_in_attack", get_parent())

func _on_btn_attack_mouse_exited() -> void:
	emit_signal("mouse_out_attack", get_parent())

#移動鍵互動
func _on_btn_move_pressed() -> void:
	pass

func refresh_value(atk: int, default: int) -> void:
	var text = str(atk)
	Global.set_font_color(text, Global.get_font_color(atk, default))
	txt_value.text = Global.set_font_center(Global.set_font_size(text, "14"))
