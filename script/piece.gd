extends Node2D

signal piece_selected(piece)
signal piece_attack(piece)
signal piece_death(piece)
signal mouse_on_attack(piece)
signal mouse_out_attack(piece)
@onready var icon_path = $Icon
@onready var player_effect = $PlayerEffect
@onready var control_panel = $ControlPanel
@onready var attack_component = $AttackComponent
@onready var health_component = $HealthComponent
@onready var location_component = $LocationComponent
@onready var select_animation_player = $SelectAnimationPlayer
#種類 玩家所屬
var type : int
var player : int
#格子的位置與圖形差距
var location : Vector2i
var icon_offset := Vector2(0, -12)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_effect.position -= icon_offset
	health_component.damaged.connect(_on_damaged)
	health_component.death.connect(_on_death)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#外觀
func load_icon() -> void:
	icon_path.texture = load(DataHandler.assets[type])
	if player == 0:
		player_effect.texture = load("res://img/piece/player/red_filter.png")
	else:
		player_effect.texture = load("res://img/piece/player/blue_filter.png")

#被選取時
func select(isSelected) -> void:
	if isSelected:
		select_animation_player.play("select")
	else:
		select_animation_player.stop()
		icon_path.modulate = Color(1, 1, 1, 1)
	if is_on_board():
		control_panel.visible = isSelected	

#是否在棋盤上
func is_on_board() -> bool:
	if location.x >= 2 && location.x <= 5:
		if location.y >= 2 && location.y < 5:
			return true
	return false

#被滑鼠按下時
func _on_icon_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("piece_selected", self)

#受到傷害時
func _on_damaged() -> void:
	#預留：受傷動畫
	pass

#死亡時
func _on_death() -> void:
	#預留：死亡動畫
	emit_signal("piece_death", self)

#攻擊鍵
func _on_attack_button_pressed() -> void:
	emit_signal("piece_attack", self)

func _on_attack_button_mouse_entered() -> void:
	emit_signal("mouse_on_attack", self)

func _on_attack_button_mouse_exited() -> void:
	emit_signal("mouse_out_attack", self)
