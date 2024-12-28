extends Control
class_name CardDetail

signal card_selected(card: Card)

@onready var lbl_card_name: RichTextLabel = $lbl_card_name
@onready var lbl_card_description: RichTextLabel = $lbl_card_description
@onready var lbl_hint: RichTextLabel = $lbl_hint
@onready var card_icon: Sprite2D = $card_icon

@onready var highlight: ColorRect = $highlight

@onready var health_states: Control = $HealthStates
@onready var health_bar: ProgressBar = $HealthStates/health_bar
@onready var health: Label = $HealthStates/lbl_health
@onready var shield_icon: TextureRect = $HealthStates/shield_icon
@onready var shield: Label = $HealthStates/lbl_shield
@onready var shield_effect: ColorRect = $HealthStates/shield_effect

@onready var max_health_state: StateDisplay = $States/max_health_state
@onready var pattern_state: StateDisplay = $States/pattern_state
@onready var attack_state: StateDisplay = $States/attack_state

@onready var buff_icon_list: BuffIconList = $Buffs
@onready var shader: ColorRect = $shader

var card_data: Card
var lbl_name_size = 20
var lbl_description_size = 16
var lbl_hint_size = 13
var lbl_hint_color = Color("b54e00")
@export var show_highlight : bool = true

#顯示棋子細節
func show_card_detail(card: Card) -> void:
	if not card: #棋子不存在
		hide()
		return
	
	card_data = card
	show()
	#圖示
	if card.has_node("OutfitComponent"):
		card_icon.texture = card.outfit_component.icon.texture
		card_icon.frame = card.outfit_component.icon.frame
	#名稱、敘述
	lbl_card_name.text = Global.set_font_size(Global.set_font_center(card.show_name), lbl_name_size)
	lbl_card_description.text = Global.set_font_size(Global.set_font_center(card.description), lbl_description_size)
	lbl_hint.text = "[i]" + Global.set_font_size(Global.set_font_center(Global.set_font_color(card.hint, lbl_hint_color)), lbl_hint_size) + "[/i]"
	lbl_hint.show()
	#最大生命、生命
	if card.has_node("HealthComponent"):
		health_states.show()
		max_health_state.show()
		max_health_state.default_value = card.health_component.DEAFULT_MAX_HEALTH
		max_health_state.value = card.health_component.max_health
		max_health_state.refresh_value_text()
		#血條
		health_bar.max_value = card.health_component.max_health
		health_bar.value = card.health_component.health
		health.text = "{0} / {1}".format([str(card.health_component.health), str(card.health_component.max_health)])
		#護盾
		if card.health_component.shield > 0:
			shield_icon.show()
			shield.show()
			shield_effect.show()
			shield.text = str(card.health_component.shield)
		else:
			shield_icon.hide()
			shield.hide()
			shield_effect.hide()
	else:
		health_states.hide()
		max_health_state.hide()
	#攻擊力、攻擊模式
	if card.has_node("AttackComponent"):
		attack_state.show()
		pattern_state.show()
		attack_state.default_value = card.attack_component.DEFAULT_ATK
		attack_state.value = card.attack_component.atk
		attack_state.refresh_value_text()
		#補上pattern_state圖示
		match card.attack_component.ATK_PATTERN:
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
			Global.PatternNames.NONE:
				pattern_state.txt_icon_texture = load("res://img/UI/attack_pattern/none.png")
		pattern_state.refresh_value_text()
	else:
		attack_state.hide()
		pattern_state.hide()
	#Buff
	if card.has_node("BuffComponent"):
		buff_icon_list.show_buffs(card.buff_component.active_buffs)
		if card.buff_component.active_buffs.size() > 0:
			lbl_hint.hide()
	else:
		buff_icon_list.show_buffs([])

func show_shader():
	shader.show()

func hide_shader():
	shader.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("card_selected", card_data)

func _on_mouse_entered() -> void:
	if show_highlight:
		highlight.show()

func _on_mouse_exited() -> void:
	highlight.hide()
