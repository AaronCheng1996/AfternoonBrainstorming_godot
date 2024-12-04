extends Node2D
class_name OutfitComponent

signal piece_selected(piece)
signal piece_attack(piece)
signal mouse_in_attack(piece)
signal mouse_out_attack(piece)
signal mouse_in_icon(piece)
signal mouse_out_icon(piece)

@export var texture_rect : TextureRect = null
@export var player_effect : TextureRect = null
@export var control_panel : Control = null
@export var move_button : Button = null
@export var attack_button : Button = null
@export var icon_offset : Vector2 = Vector2(0, 0)
@export var effect_offset : Vector2 = Vector2(0, 12)

func _ready() -> void:
	#非選定狀態時隱藏
	control_panel.visible = false
	#連接圖示
	texture_rect.global_position += icon_offset
	texture_rect.gui_input.connect(_on_icon_gui_input)
	texture_rect.mouse_entered.connect(_on_icon_mouse_entered)
	texture_rect.mouse_exited.connect(_on_icon_mouse_exited)
	#連接攻擊鍵
	attack_button.pressed.connect(_on_attack_button_pressed)
	attack_button.mouse_entered.connect(_on_attack_button_mouse_entered)
	attack_button.mouse_exited.connect(_on_attack_button_mouse_exited)

#套用玩家特效
func set_player_effect(player: int) -> void:
	player_effect.position += effect_offset
	if player == 0:
		player_effect.texture = load("res://img/piece/player/red_filter.png")
	else:
		player_effect.texture = load("res://img/piece/player/blue_filter.png")

#被選取時
func select(is_selected: bool, is_on_board: bool) -> void:
	#選取動畫
	if is_on_board:
		control_panel.visible = is_selected	

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
