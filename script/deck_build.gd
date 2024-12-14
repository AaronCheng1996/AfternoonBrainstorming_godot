extends Control

@onready var player = preload("res://scenes/Resource/player.tscn")
@onready var piece_detail = preload("res://scenes/UI/piece_detail.tscn")

@onready var players: Node2D = $players
@onready var pieces: Node2D = $piece_list/pieces
@onready var temp: Node2D = $decks/temp

@onready var piece_grid: GridContainer = $piece_list/grid_background/ScrollContainer/piece_grid
@onready var btn_start: Button = $btn_start
@onready var message: Label = $message

@onready var deck_background_0: ColorRect = $decks/deck_background_0
@onready var deck_background_1: ColorRect = $decks/deck_background_1
@onready var deck_grid_0: GridContainer = $decks/deck_background_0/deck_grid_0
@onready var deck_grid_1: GridContainer = $decks/deck_background_1/deck_grid_1
@onready var select_highlight: ColorRect = $decks/select_highlight

var player_list := []
var current_turn = 1
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

var select_highlight_offset = Vector2(-5, -5)
var deck_icon_size = Vector2(40, 40)

#開始遊戲
func _ready() -> void:
	#建立玩家資料
	for i in range(2):
		var new_player = player.instantiate()
		new_player.id = i
		player_list.append(new_player)
		players.add_child(new_player)
	#載入棋子選單
	for i in range(piece_types.size()):
		var piece_scene = load(piece_types[i])
		var new_piece : Piece = piece_scene.instantiate()
		pieces.add_child(new_piece)
		var new_piece_detail = piece_detail.instantiate()
		piece_grid.add_child(new_piece_detail)
		new_piece_detail.show_piece_detail(new_piece)
		new_piece_detail.piece_selected.connect(_on_piece_selected)

func _process(delta: float) -> void:
	#選卡順序 先手玩家挑6張 -> 後首玩家挑12張 -> 先手玩家挑6張
	if player_list[1].deck.size() < Global.deck_size / 2:
		current_turn = 1
	elif player_list[0].deck.size() < Global.deck_size:
		current_turn = 0
	elif player_list[1].deck.size() < Global.deck_size:
		current_turn = 1
	else:
		select_highlight.visible = false
	#當前選牌玩家特效
	if current_turn == 1:
		select_highlight.position = deck_background_1.position + select_highlight_offset
	else:
		select_highlight.position = deck_background_0.position + select_highlight_offset
	#當雙方選完牌組後才能開始遊戲
	if player_list[0].deck.size() == Global.deck_size and player_list[1].deck.size() == Global.deck_size:
		btn_start.disabled = false
	else:
		btn_start.disabled = true

#開始遊戲
func _on_start_button_pressed() -> void:
	#生成該局種子碼
	Global.rng.randomize()
	Global.seed = Global.rng.randi_range(0, 999999)
	Global.rng.seed = Global.seed
	#洗牌
	for i in range(2):
		player_list[i].deck = shuffle_deck(player_list[i].deck)
	#加載並切換到新場景
	var match_scene = preload("res://scenes/match.tscn").instantiate()
	match_scene.set_player(player_list)
	get_parent().add_child(match_scene)
	get_parent().remove_child(self)

#玩家選牌
func _on_piece_selected(piece: Piece) -> void:
	if player_list[0].deck.size() >= Global.deck_size and player_list[1].deck.size() >= Global.deck_size: #雙方玩家手牌已滿
		message.pop_message(Global.data.message.deck_full)
		return
	if not player_list[current_turn].deck_piece_type.has(piece.show_name): #紀錄玩家持有該棋子數量
		player_list[current_turn].deck_piece_type[piece.show_name] = 0
	if player_list[current_turn].deck_piece_type[piece.show_name] >= Global.type_limit: #該棋子數量已達上限
		message.pop_message(Global.data.message.piece_limit)
		return
	#將棋子新增至玩家牌組
	var new_piece = piece.duplicate()
	new_piece.piece_owner = player_list[current_turn]
	new_piece.is_on_board = false
	player_list[current_turn].deck.append(new_piece)
	player_list[current_turn].deck_piece_type[piece.show_name] += 1
	#新增至牌組顯示
	if current_turn == 0:
		deck_grid_0.add_child(get_icon(new_piece))
	else:
		deck_grid_1.add_child(get_icon(new_piece))

#取得圖示
func get_icon(piece: Piece) -> TextureRect:
	var temp_piece = piece.duplicate()
	temp.add_child(temp_piece)
	var icon = TextureRect.new()
	icon.texture = temp_piece.outfit_component.icon.texture
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = deck_icon_size
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
