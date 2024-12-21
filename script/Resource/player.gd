extends Control
class_name Player

signal player_draw_card(player: Player, card: Card)
signal player_discard_card(card: Card)

var id : int
var deck := []
var deck_card_type := {}
var hand := []
var grave := []
var buff_history := []
var attack_count : int = 0

@onready var buff_component : BuffComponent = $BuffComponent
@onready var attack_state : StateDisplay = $background/AttackCount
@onready var deck_state : StateDisplay = $background/DeckCount
@onready var grave_state : StateDisplay = $background/GraveCount

func _ready() -> void:
	add_attack_count(0)
	deck_state.refresh_value_text()
	grave_state.refresh_value_text()

func _process(delta: float) -> void:
	#更新牌庫、棄牌堆資訊
	if deck.size() != deck_state.value:
		deck_state.default_value = deck.size()
		deck_state.value = deck.size()
		deck_state.refresh_value_text()
	if grave.size() != grave_state.value:
		grave_state.default_value = grave.size()
		grave_state.value = grave.size()
		grave_state.refresh_value_text()

#管理攻擊次數
func add_attack_count(value: int) -> void:
	attack_count += value
	attack_state.default_value = attack_count
	attack_state.value = attack_count
	attack_state.refresh_value_text()

#抽牌
func draw_card() -> void:
	if hand.size() >= Global.hand_size: #手上沒有空間
		return
	if deck.size() == 0: #空牌庫
		reshuffle()
	if deck.size() == 0:
		return
	#抽出牌，將其實例化
	var card = deck.pop_front()
	hand.append(card)
	emit_signal("player_draw_card", self, card)

#獲得牌
func get_card(card: Card) -> void:
	if hand.size() >= Global.hand_size: #手上沒有空間
		return
	hand.append(card)
	emit_signal("player_draw_card", self, card)

#捨棄手牌
func discard(card: Card) -> void:
	hand.erase(card)
	grave.append(card)
	emit_signal("player_discard_card", card)


#重新洗牌
func reshuffle() -> void:
	deck.append_array(grave)
	grave.clear()
	Global.shuffle_deck(deck)
