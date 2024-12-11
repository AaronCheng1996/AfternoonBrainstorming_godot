extends Control

@onready var piece_detail = preload("res://scenes/UI/piece_detail.tscn")
@onready var piece_grid: GridContainer = $grid_background/ScrollContainer/piece_grid
@onready var btn_start: Button = $btn_start
@onready var pieces = $pieces
@onready var deck_grid_0: GridContainer = $decks/deck_background_0/deck_grid_0
@onready var deck_grid_1: GridContainer = $decks/deck_background_1/deck_grid_1
@onready var select_highlight: ColorRect = $decks/select_highlight
@onready var temp: Node2D = $decks/temp

var current_turn = 1
var deck_size = 12
var deck := []
var piece_limit = 2
var piece_types = [
	"res://scenes/pieces/white/white_adc.tscn",
	"res://scenes/pieces/white/white_ap.tscn",
	"res://scenes/pieces/white/white_apt.tscn",
	"res://scenes/pieces/white/white_ass.tscn",
	"res://scenes/pieces/white/white_hf.tscn",
	"res://scenes/pieces/white/white_lf.tscn", 
	"res://scenes/pieces/white/white_sp.tscn", 
	"res://scenes/pieces/white/white_tank.tscn",
]
var deck_card_type := []

func _ready() -> void:
	#生成該局種子碼
	Global.seed = 12345
	Global.rng = RandomNumberGenerator.new()
	Global.rng.seed = Global.seed
	#正式開始遊戲
	#建立牌組陣列
	for i in range(2):
		deck.append([])
		deck_card_type.append({})
	#載入棋子選單
	for i in range(piece_types.size()):
		var piece_scene = load(piece_types[i])
		var new_piece : Piece = piece_scene.instantiate()
		pieces.add_child(new_piece)
		var new_piece_detail = piece_detail.instantiate()
		piece_grid.add_child(new_piece_detail)
		new_piece_detail.show_piece_detail(new_piece)
		new_piece_detail.piece_selected.connect(_on_piece_selected)
	#牌組
	show_deck()

func _process(delta: float) -> void:
	if deck.size() != 2:
		return
	#選卡順序 先手玩家挑6張 -> 後首玩家挑12張 -> 先手玩家挑6張
	if deck[1].size() < 6:
		current_turn = 1
	elif deck[0].size() < 12:
		current_turn = 0
	elif deck[1].size() < 12:
		current_turn = 1
	else:
		select_highlight.visible = false
	#當前選牌玩家特效
	if current_turn == 1:
		select_highlight.position.y = 395
	else:
		select_highlight.position.y = 125
	#當雙方選完牌組後才能開始遊戲
	if deck[0].size() == deck_size and deck[1].size() == deck_size:
		btn_start.disabled = false
	else:
		btn_start.disabled = true

#開始遊戲
func _on_start_button_pressed() -> void:
	#獲取當前主場景
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()  #移除當前場景
	#加載並切換到新場景
	var match_scene = preload("res://scenes/match.tscn").instantiate()
	#洗牌
	deck[0] = shuffle_deck(deck[0])
	deck[1] = shuffle_deck(deck[1])
	match_scene.set_deck(deck)
	get_tree().root.add_child(match_scene)

#玩家選牌
func _on_piece_selected(piece: Piece) -> void:
	if deck[0].size() >= 12 and deck[1].size() >= 12: #雙方玩家手牌未滿
		return
	if not deck_card_type[current_turn].has(piece.show_name): #紀錄玩家持有該棋子數量
		deck_card_type[current_turn][piece.show_name] = 0
	if deck_card_type[current_turn][piece.show_name] >= piece_limit: #該棋子數量已達上限
		return
	#將棋子新增至玩家牌組
	var new_piece = piece.duplicate()
	new_piece.player = current_turn
	new_piece.is_on_board = false
	deck[current_turn].append(new_piece)
	deck_card_type[current_turn][piece.show_name] += 1
	show_deck()

#刷新牌組顯示
func show_deck() -> void:
	#先移除原本資料
	for child in deck_grid_0.get_children():
		child.queue_free()
	for child in deck_grid_1.get_children():
		child.queue_free()
	for child in temp.get_children():
		temp.remove_child(child)
	#歷遍牌組內所有棋子並顯示
	for piece in deck[0]: #玩家1區域
		deck_grid_0.add_child(get_icon(piece))
	for piece in deck[1]: #玩家2區域
		deck_grid_1.add_child(get_icon(piece))

#取得圖示
func get_icon(piece: Piece) -> TextureRect:
	var temp_piece = piece.duplicate()
	temp.add_child(temp_piece)
	var icon = TextureRect.new()
	icon.texture = temp_piece.outfit_component.icon.texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = Vector2(40, 40)
	return icon

#Fisher-Yates洗牌
func shuffle_deck(deck: Array) -> Array:
	var shuffled_deck = deck.duplicate()
	for i in range(shuffled_deck.size() - 1, 0, -1):
		#使用 rng 生成隨機索引
		var j = Global.rng.randi_range(0, i)
		var temp = shuffled_deck[i]
		shuffled_deck[i] = shuffled_deck[j]
		shuffled_deck[j] = temp
	return shuffled_deck
