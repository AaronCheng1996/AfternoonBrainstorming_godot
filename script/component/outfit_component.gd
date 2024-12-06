extends Node2D
class_name OutfitComponent

signal piece_selected(piece: Piece)
signal piece_attack(piece: Piece)
signal mouse_in_attack(piece: Piece)
signal mouse_out_attack(piece: Piece)
signal mouse_in_icon(piece: Piece)
signal mouse_out_icon(piece: Piece)

@onready var player_effect = $PlayerEffect

@export var ICON : TextureRect
@export var CONTROL_PANEL : Control
@export var MOVE_BUTTON : Button
@export var ATTACK_BUTTON : Button
@export var effect_offset : Vector2 = Vector2(0, 12)

func _ready() -> void:
	#非選定狀態時隱藏
	if CONTROL_PANEL:
		CONTROL_PANEL.visible = false
	#圖示
	if ICON:
		ICON.gui_input.connect(_on_icon_gui_input)
		ICON.mouse_entered.connect(_on_icon_mouse_entered)
		ICON.mouse_exited.connect(_on_icon_mouse_exited)
	#攻擊鍵
	if ATTACK_BUTTON:
		ATTACK_BUTTON.pressed.connect(_on_attack_button_pressed)
		ATTACK_BUTTON.mouse_entered.connect(_on_attack_button_mouse_entered)
		ATTACK_BUTTON.mouse_exited.connect(_on_attack_button_mouse_exited)
	#移動鍵
	enable_move(false)

#套用玩家特效
func set_player_effect(player: int) -> void:
	player_effect.position += effect_offset
	if player == 0:
		player_effect.texture = load("res://img/piece/player/red_filter.png")
	if player == 1:
		player_effect.texture = load("res://img/piece/player/blue_filter.png")

#被選取時
func show_control_panel(show: bool) -> void:
	if CONTROL_PANEL:
		CONTROL_PANEL.visible = show

#無效攻擊
func enable_attack(enable) -> void:
	if ATTACK_BUTTON:
		ATTACK_BUTTON.disabled = !enable

#無效移動
func enable_move(enable) -> void:
	if MOVE_BUTTON:
		MOVE_BUTTON.disabled = !enable

#圖示互動
func _on_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", get_parent())

func _on_icon_mouse_entered() -> void:
	emit_signal("mouse_in_icon", get_parent())

func _on_icon_mouse_exited() -> void:
	emit_signal("mouse_out_icon", get_parent())

#攻擊鍵互動
func _on_attack_button_pressed() -> void:
	emit_signal("piece_attack", get_parent())

func _on_attack_button_mouse_entered() -> void:
	emit_signal("mouse_in_attack", get_parent())

func _on_attack_button_mouse_exited() -> void:
	emit_signal("mouse_out_attack", get_parent())

#移動鍵互動
func _on_move_button_pressed() -> void:
	pass # Replace with function body.
