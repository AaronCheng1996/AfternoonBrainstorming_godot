extends Control

const PLAYER = preload("res://scenes/Resource/player.tscn")
const PIECE_DETAIL = preload("res://scenes/UI/piece_detail.tscn")
const PIECE_GROUP_BUTTON = preload("res://scenes/UI/piece_group_button.tscn")
const PIECE_ICON = preload("res://scenes/UI/piece_icon.tscn")

@onready var players: Control = $Players
@onready var pieces: Node2D = $PieceList/Pieces
@onready var temp: Node2D = $Decks/Temp
@onready var piece_grid: GridContainer = $PieceList/background/scroll_container/piece_grid

@onready var btn_start: Button = $btn_start
@onready var message: Label = $Message
@onready var piece_group: GridContainer = $PieceList/piece_group

@onready var select_highlight: ColorRect = $Decks/select_highlight
@onready var deck_0: ColorRect = $Decks/deck_background_0
@onready var deck_1: ColorRect = $Decks/deck_background_1
@onready var full_deck_0: ColorRect = $Decks/full_deck_background_0
@onready var full_deck_1: ColorRect = $Decks/full_deck_background_1
@onready var btn_show_all_0: Button = $Decks/deck_background_0/btn_show_all_0
@onready var btn_show_all_1: Button = $Decks/deck_background_1/btn_show_all_1

var player_list := []
var current_turn :  = 1
var decks := []
var deck_show : int = 6
var select_highlight_offset : Vector2 = Vector2(-5, -5)
var player_offset : Vector2 = Vector2(52, 64)
var deck_col : int = 2
var icon_size : Vector2 = Vector2(62, 62)
var selected_group : PieceGroupButton = null

#開始遊戲
func _ready() -> void:
	#建立玩家資料
	for i in range(2):
		var new_player = PLAYER.instantiate()
		new_player.id = i
		player_list.append(new_player)
		players.add_child(new_player)
		new_player.position = Vector2(0, 560 * i) + player_offset
	#建立牌組顯示
	decks = [deck_0, deck_1, full_deck_0, full_deck_1]
	#建立選牌派別群組
	set_groups()
	refresh()

#建立派別分頁資訊
func set_groups() -> void:
	var group_all := []
	#取得各個派別
	for group in Global.piece_groups:
		group_all.append_array(Global.piece_groups[group])
		var group_data = Global.data.piece[group]
		var new_group_button = PIECE_GROUP_BUTTON.instantiate()
		piece_group.add_child(new_group_button)
		#設定按鈕
		new_group_button.group = Global.piece_groups[group]
		new_group_button.label_font_color = Color(group_data.color)
		new_group_button.set_text(group_data.name.replace("色", ""))
		new_group_button.group_selected.connect(_on_piece_group_button_group_selected)
		if not selected_group:
			selected_group = new_group_button
			new_group_button.selected()
	#顯示所有派別
	var all_group_button = PIECE_GROUP_BUTTON.instantiate()
	piece_group.add_child(all_group_button)
	all_group_button.group = group_all
	all_group_button.label_font_color = Color.GRAY
	all_group_button.set_text("全")
	all_group_button.group_selected.connect(_on_piece_group_button_group_selected)

#切換派別頁面
func _on_piece_group_button_group_selected(group: PieceGroupButton) -> void:
	selected_group.unselected()
	load_piece_grid(group.group)
	selected_group = group
	group.selected()

#刷新畫面資訊
func refresh() -> void:
	#選卡順序 先手玩家挑6張 -> 後首玩家挑12張 -> 先手玩家挑6張
	select_highlight.show()
	if player_list[1].deck.size() < Global.deck_size / 2:
		current_turn = 1
	elif player_list[0].deck.size() < Global.deck_size:
		current_turn = 0
	elif player_list[1].deck.size() < Global.deck_size:
		current_turn = 1
	else:
		select_highlight.hide()
		current_turn = -1
	#當前選牌玩家特效
	if current_turn == 1:
		select_highlight.position = deck_1.position + select_highlight_offset
	else:
		select_highlight.position = deck_0.position + select_highlight_offset
	#當雙方選完牌組後才能開始遊戲
	if player_list[0].deck.size() == Global.deck_size and player_list[1].deck.size() == Global.deck_size:
		btn_start.disabled = false
	else:
		btn_start.disabled = true
	load_piece_grid(selected_group.group)

#載入棋子選單
func load_piece_grid(piece_groups: Array) -> void:
	#移除先前版面
	for child in pieces.get_children():
		child.queue_free()
	for child in piece_grid.get_children():
		child.queue_free()
	#列出每種棋子
	for piece_group in piece_groups:
		#建立棋子
		var piece_scene = load(piece_group)
		var new_piece : Piece = piece_scene.instantiate()
		pieces.add_child(new_piece)
		#建立棋子資料顯示
		var new_piece_detail : PieceDetail = PIECE_DETAIL.instantiate()
		piece_grid.add_child(new_piece_detail)
		new_piece_detail.show_piece_detail(new_piece)
		new_piece_detail.piece_selected.connect(_on_piece_selected)
		#超過上限或已挑完排組
		if current_turn == -1:
			new_piece_detail.show_shader()
			continue
		if not player_list[current_turn].deck_piece_type.has(new_piece.show_name): #紀錄玩家持有該棋子數量
			player_list[current_turn].deck_piece_type[new_piece.show_name] = 0
		if player_list[current_turn].deck_piece_type[new_piece.show_name] >= Global.type_limit:
			new_piece_detail.show_shader()
		else:
			new_piece_detail.hide_shader()
		

#開始遊戲
func _on_start_button_pressed() -> void:
	#生成該局種子碼
	Global.rng.randomize()
	Global.seed = Global.rng.randi_range(0, 999999)
	Global.rng.seed = Global.seed
	print(Global.seed)
	#洗牌
	for i in range(2):
		player_list[i].deck = Global.shuffle_deck(player_list[i].deck)
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
	show_deck()
	
#顯示牌組
func show_deck() -> void:
	#清除原先內容
	for piece in temp.get_children():
		piece.queue_free()
	for deck in decks:
		for object in deck.get_children():
			if object.get_class() == "Control":
				object.queue_free()
	#建立新牌圖示
	for player in player_list.size(): #每個玩家
		for i in player_list[player].deck.size(): #牌庫
			#產生臨時的棋子實體
			var temp_piece: Piece = player_list[player].deck[i].duplicate()
			temp.add_child(temp_piece)
			#新增至牌組顯示
			var icon : PieceIcon = PIECE_ICON.instantiate()
			icon.player_num = player
			icon.index = i
			icon.show_name = temp_piece.show_name
			#根據目前持有人進入哪個牌庫顯示
			if i < deck_show:
				icon.position = Vector2( icon_size.x * (i % deck_col), icon_size.y * (i / deck_col))
				decks[player].add_child(icon)
			else:
				icon.position = Vector2( icon_size.x * ((i - deck_show) % deck_col), icon_size.y * ((i - deck_show) / deck_col))
				decks[player + 2].add_child(icon)
			icon.icon.texture = temp_piece.outfit_component.icon.texture
			icon.icon.hframes = temp_piece.outfit_component.icon.hframes
			icon.icon.vframes = temp_piece.outfit_component.icon.vframes
			icon.icon.frame = temp_piece.outfit_component.icon.frame
			icon.remove.connect(on_icon_remove)
	refresh()

#移除棋子
func on_icon_remove(icon: PieceIcon) -> void:
	player_list[icon.player_num].deck.pop_at(icon.index)
	player_list[icon.player_num].deck_piece_type[icon.show_name] -= 1
	show_deck()

#展開/縮小牌組
func _on_show_all_1_pressed() -> void:
	if full_deck_1.visible:
		btn_show_all_1.text = ">"
		full_deck_1.hide()
	else:
		btn_show_all_1.text = "<"
		full_deck_1.show()
func _on_show_all_0_pressed() -> void:
	if full_deck_0.visible:
		btn_show_all_0.text = ">"
		full_deck_0.hide()
	else:
		btn_show_all_0.text = "<"
		full_deck_0.show()
