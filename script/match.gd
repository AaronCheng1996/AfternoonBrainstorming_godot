extends Control
#棋子
@onready var piece_scene = preload("res://scenes/piece.tscn")
@onready var board = $Board
@onready var p1_pieces = $Board/Pieces/Player1
@onready var p2_pieces = $Board/Pieces/Player2
@onready var tilemap = $Board/TileMap
#牌庫
var deck_size = 12
var deck := []
#場面
var gird_size = 4
var board_piece_dic := {}
#手牌
var hand_size = 8
var starter_hand_count = 4
var hand_piece_array := []
#棋子座標修正
var icon_offset := Vector2(112, -28)
#選定的棋子
var piece_selected = null
#當前回合
var player_turn = 0
#分數
var score = 15

#生成
func _ready() -> void:
	#生成棋盤陣列
	for x in gird_size:
		for y in gird_size:
			board_piece_dic[str(Vector2(x + 2, y + 2))] = 0
	#生成2位玩家手牌陣列
	for player in range(2):
		hand_piece_array.append([])
		hand_piece_array[player].resize(hand_size)
		hand_piece_array[player].fill(0)
		
		#測試用 牌庫陣列
		#create_test_deck(player)
		
		for i in range(starter_hand_count):
			draw_piece(player)
	
	tilemap.tile_selected.connect(_on_tile_clicked)
	start_turn(0)

#每 frame 執行
func _process(delta: float) -> void:
	pass

#region 流程

func set_deck(new_deck: Array) -> void:
	deck = new_deck

#回合開始
func start_turn(player) -> void:
	select_piece(null)
	draw_piece(player)

#回合結束
func end_turn() -> void:
	calculate_score(player_turn)
	if player_turn == 0:
		player_turn = 1
	else:
		player_turn = 0
	start_turn(player_turn)

#抽牌
func draw_piece(player) -> void:
	if hand_piece_array[player].count(0) <= 0: #手上沒有空間
		return
	if deck.size() == 0:
		return
	if deck[player].size() == 0: #空牌庫
		return
	
	var piece = deck[player].pop_front()
	if player == 0:
		p1_pieces.add_child(piece)
	else:
		p2_pieces.add_child(piece)
	var empty = hand_piece_array[player].find(0)
	piece.outfit_component.set_player_effect(player)
	piece.global_position = tilemap.map_to_local(Vector2(empty, player * 7)) + icon_offset
	piece.location = Vector2(empty, player * 7)
	hand_piece_array[player][empty] = piece
	#連結
	piece.outfit_component.piece_selected.connect(_on_piece_selected)
	piece.outfit_component.piece_attack.connect(_on_piece_attack)
	piece.outfit_component.mouse_in_icon.connect(_on_mouse_in_icon)
	piece.outfit_component.mouse_out_icon.connect(_on_mouse_out_icon)
	piece.outfit_component.mouse_in_attack.connect(_on_mouse_in_attack)
	piece.outfit_component.mouse_out_attack.connect(_on_mouse_out_attack)
	piece.piece_death.connect(_on_piece_death)

#計分
func calculate_score(player) -> void:
	pass

#endregion

#region 觸發

#選取棋子
func _on_piece_selected(piece):
	if not player_turn == piece.player:
		return
	if not piece_selected: #若目前沒有選定的棋子
		select_piece(piece)
	else: #若目前已有選定的棋子
		if piece_selected == piece: #若再選定一次自己則取消選定
			select_piece(null)
		else: #轉而選定其他的棋子
			if (!is_on_board(piece.location) and !is_on_board(piece_selected.location)) and piece.player == piece_selected.player:
				swap_piece_in_hand(piece, piece_selected)
				select_piece(null)
			else:
				select_piece(piece)
			
#棋子發動攻擊
func _on_piece_attack(piece):
	var target := []
	if piece.player == 0:
		target = p2_pieces.get_children()
	else:
		target = p1_pieces.get_children()
	piece.attack_component.attack(target)

#選取格子時
func _on_tile_clicked(location) -> void:
	if not piece_selected: #沒有先選定棋子
		return
	if piece_selected.location == location:
		return
	
	if not is_on_board(piece_selected.location):
		if is_on_board(location):
			move_piece_to_board(piece_selected, location)
		else:
			move_piece_in_hand(piece_selected, location)
		piece_selected.outfit_component.select(false, is_on_board(piece_selected.location))
		piece_selected = null
		tilemap.piece_select = null

#滑鼠在攻擊鍵上
func _on_mouse_in_icon(piece):
	pass

#滑鼠離開攻擊鍵上
func _on_mouse_out_icon(piece):
	pass

#滑鼠在攻擊鍵上
func _on_mouse_in_attack(piece):
	var target := []
	if piece.player == 0:
		target = p2_pieces.get_children()
	else:
		target = p1_pieces.get_children()
	tilemap.show_attack_target(piece.attack_component.get_target_location(target))

#滑鼠離開攻擊鍵上
func _on_mouse_out_attack(piece):
	tilemap.reset(1)

#棋子死亡
func _on_piece_death(piece):
	board_piece_dic[str(piece.location)] = 0
	piece.queue_free()

#endregion

#region 選定/移動

#選定/取消選定棋子時
func select_piece(piece):
	if piece != null: #選定
		if piece_selected != null: #若原本有其他選定的目標，清除選定特效
			piece_selected.outfit_component.select(false, is_on_board(piece_selected.location))
			tilemap.piece_select = null
		#選定目標，並為格子加上選定特效
		piece_selected = piece
		piece_selected.outfit_component.select(true, is_on_board(piece_selected.location))
		tilemap.piece_select = piece
	else: #取消選定
		if piece_selected == null:
			return
		piece_selected.outfit_component.select(false, is_on_board(piece_selected.location))
		piece_selected = null
		tilemap.piece_select = null

#移動場上棋子
func move_piece(piece, location) -> void:
	if board_piece_dic[str(location)] is not int:
		return
	board_piece_dic[str(piece.location)] = 0
	board_piece_dic[str(location)] = piece
	piece.global_position = tilemap.map_to_local(location) + icon_offset
	piece.location = location

#將手上的棋子放置到場上
func move_piece_to_board(piece, location) -> void:
	if board_piece_dic[str(location)] is not int:
		return
	hand_piece_array[piece.player][piece.location.x] = 0
	board_piece_dic[str(location)] = piece
	piece.global_position = tilemap.map_to_local(location) + icon_offset
	piece.location = location

#移動手上的棋子順序
func move_piece_in_hand(piece, location) -> void:
	if not piece.player * 7 == location.y:
		return
	if hand_piece_array[piece.player][location.x] is not int:
		return
	hand_piece_array[piece.player][piece.location.x] = 0
	hand_piece_array[piece.player][location.x] = piece
	piece.global_position = tilemap.map_to_local(location) + icon_offset
	piece.location = location

func swap_piece_in_hand(piece1, piece2) -> void:
	var temp = piece1
	var temp_p1_location = piece1.location
	var temp_p2_location = piece2.location
	hand_piece_array[piece1.player][temp_p1_location.x] = piece2
	hand_piece_array[piece1.player][temp_p2_location.x] = temp
	piece1.global_position = tilemap.map_to_local(temp_p2_location) + icon_offset
	piece2.global_position = tilemap.map_to_local(temp_p1_location) + icon_offset
	piece1.location = temp_p2_location
	piece2.location = temp_p1_location

#endregion

#region 判斷

#判斷棋子是否在棋盤上
func is_on_board(location: Vector2i) -> bool:
	if location.x >= 2 and location.x <= 5:
		if location.y >= 2 and location.y <= 5:
			return true
	return false
	
#endregion

#region 測試
#生成棋子種類佇列
var piece_type = [
	DataHandler.PieceNames.WHITE_ASS,
	DataHandler.PieceNames.WHITE_CUBE,
	DataHandler.PieceNames.WHITE_DIAMOND,
	DataHandler.PieceNames.WHITE_DLOZ,
	DataHandler.PieceNames.WHITE_HEX,
	DataHandler.PieceNames.WHITE_SPHERE,
	DataHandler.PieceNames.WHITE_TRAP,
	DataHandler.PieceNames.WHITE_TRI
]

#加入棋子
func _on_button_pressed() -> void:
	draw_piece(0)

func _on_button_2_pressed() -> void:
	draw_piece(1)

#切換回合
func _on_turn_end_button_pressed() -> void:
	end_turn()
#endregion
