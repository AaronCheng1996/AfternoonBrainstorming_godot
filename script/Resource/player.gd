extends Control
class_name Player

var id : int
var deck := []
var deck_piece_type := {}
var hand := []
var grave := []
var attack_count : int = 0

@onready var buff_component: BuffComponent = $BuffComponent
@onready var attack_state: PieceState = $background/AttackCount
@onready var deck_state: PieceState = $background/DeckCount
@onready var grave_state: PieceState = $background/GraveCount

func _ready() -> void:
	hand.resize(Global.hand_size)
	hand.fill(0)
	add_attack_count(0)
	deck_state.refresh_value_text()
	grave_state.refresh_value_text()

func _process(delta: float) -> void:
	if deck.size() != deck_state.value:
		deck_state.default_value = deck.size()
		deck_state.value = deck.size()
		deck_state.refresh_value_text()
	if grave.size() != grave_state.value:
		grave_state.default_value = grave.size()
		grave_state.value = grave.size()
		grave_state.refresh_value_text()

func add_attack_count(value: int) -> void:
	attack_count += value
	attack_state.default_value = attack_count
	attack_state.value = attack_count
	attack_state.refresh_value_text()
