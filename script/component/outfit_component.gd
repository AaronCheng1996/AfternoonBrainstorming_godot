extends Node2D
class_name OutfitComponent

signal piece_selected(piece: Piece)
signal piece_attack(piece: Piece)
signal mouse_in_attack(piece: Piece)
signal mouse_out_attack(piece: Piece)
signal mouse_in_icon(piece: Piece)
signal mouse_out_icon(piece: Piece)

@onready var player_effect: TextureRect = $player_effect
@onready var txt_value: RichTextLabel = $txt_value
@onready var control_panel: Control = $ControlPanel
@onready var move_button: Button = $ControlPanel/btn_move
@onready var attack_button: Button = $ControlPanel/btn_attack
@onready var icon: TextureRect = $Icon
@export var icon_texture : CompressedTexture2D

var txt_size = 14

func _ready() -> void:
	#非選定狀態時隱藏
	if control_panel:
		control_panel.hide()
	#圖示
	if icon_texture:
		icon.texture = icon_texture
	#按鈕
	disable_move()

#套用玩家特效
func set_player_effect(player: int) -> void:
	if player == 0:
		player_effect.texture = load("res://img/piece/player/red_filter.png")
	if player == 1:
		player_effect.texture = load("res://img/piece/player/blue_filter.png")

#開啟選取特效
func show_control_panel() -> void:
	if control_panel:
		control_panel.show()
#關閉選取特效
func hide_control_panel() -> void:
	if control_panel:
		control_panel.hide()
#無效攻擊
func enable_attack() -> void:
	if attack_button:
		attack_button.disabled = false
func disable_attack() -> void:
	if attack_button:
		attack_button.disabled = true
#無效移動
func enable_move() -> void:
	if move_button:
		move_button.disabled = false
func disable_move() -> void:
	if move_button:
		move_button.disabled = true

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
	txt_value.text = Global.set_font_center(Global.set_font_size(text, txt_size))
