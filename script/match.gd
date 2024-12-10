extends Control

@onready var p0_pieces = $board/Pieces/Player0
@onready var p1_pieces = $board/Pieces/Player1
@onready var board: ColorRect = $board
@onready var tilemap: TileMap = $board/TileMap
@onready var p0_end_button: Button = $board/btn_turn_end_0
@onready var p1_end_button: Button = $board/btn_turn_end_1
@onready var piece_detail: PieceDetail = %piece_detail
@onready var pieces: Node2D = $board/Pieces
@onready var score_label: RichTextLabel = $board/score_label
#牌庫
var deck_size : int = 12
var deck := []
#場面
var gird_size : int = 4
var board_piece_dic := {}
#手牌
var hand_size : int = 8
var starter_hand_count : int = 4
var hand_piece_array := []
#墓園
var graveyard := []

#選定的棋子
var piece_selected : Piece = null
#當前回合
var player_turn : int = 1
#分數
var score_color : String = "white"
var score : int = 0

#生成
func _ready() -> void:
	print(get_tree().root.get_children())
	#生成棋盤陣列
	for x in gird_size:
		for y in gird_size:
			board_piece_dic[str(Vector2(x + 2, y + 2))] = 0
	#分別為2位玩家
	for player in range(2):
		#生成手牌陣列
		hand_piece_array.append([])
		hand_piece_array[player].resize(hand_size)
		hand_piece_array[player].fill(0)
		#生成墓地
		graveyard.append([])
	#抽上起手牌
	for i in range(starter_hand_count - 1):
		draw_piece(1)
	for i in range(starter_hand_count):
		draw_piece(0)

	tilemap.tile_selected.connect(_on_tile_clicked)
	start_turn(player_turn)

#region 流程

#設定雙方牌組
func set_deck(new_deck: Array) -> void:
	deck = new_deck

#回合開始
func start_turn(player: int) -> void:
	tilemap.current_player = player
	#所有場上棋子
	for index in board_piece_dic:
		if board_piece_dic[index] is int:
			continue
		#棋子執行回合開始效果
		board_piece_dic[index].on_turn_start(player_turn)
	#抽牌
	draw_piece(player)

#回合結束
func end_turn() -> void:
	#所有場上棋子
	for index in board_piece_dic:
		if board_piece_dic[index] is int:
			continue
		var piece = board_piece_dic[index]
		#計分
		score += piece.get_score(player_turn)
		if score < 0:
			score_color = "red"
		elif score > 0:
			score_color = "blue"
		else:
			score_color = "white"
		score_label.text = Global.set_font_center(Global.set_font_color(Global.set_font_size(str(abs(score)), "60"), score_color))
		#得分超過 10 則獲勝
		if abs(score) >= 10:
			var winner = -1
			if score > 0:
				winner = 0
			else:
				winner = 1
			#獲取當前主場景
			var current_scene = get_tree().current_scene
			if current_scene:
				current_scene.queue_free()  #移除當前場景
			#加載並切換到新場景
			var end_scene = preload("res://scenes/end.tscn").instantiate()
			end_scene.set_winner(winner)
			get_tree().root.add_child(end_scene)
		#棋子執行回合結束效果
		piece.on_turn_end(player_turn)
		
	#解除所有鎖定
	select_piece(null)
	#換邊開始回合
	if player_turn == 1:
		player_turn = 0
		p0_end_button.disabled = false
		p1_end_button.disabled = true
	else:
		player_turn = 1
		p0_end_button.disabled = true
		p1_end_button.disabled = false
	start_turn(player_turn)

#抽牌
func draw_piece(player: int) -> void:
	if hand_piece_array[player].count(0) <= 0: #手上沒有空間
		return
	if deck.size() == 0:
		return
	if deck[player].size() == 0: #空牌庫
		return
	
	var piece = deck[player].pop_front()
	if player == 0:
		p0_pieces.add_child(piece)
	else:
		p1_pieces.add_child(piece)
	var empty = hand_piece_array[player].find(0)
	
	piece.position = tilemap.map_to_local(Vector2(empty, player * 7))
	piece.location = Vector2(empty, player * 7)
	hand_piece_array[player][empty] = piece
	#設定外觀與連結
	if piece.get_node_or_null("OutfitComponent"):
		piece.outfit_component.set_player_effect(player)
		piece.outfit_component.piece_selected.connect(_on_piece_selected)
		piece.outfit_component.piece_attack.connect(_on_piece_attack)
		piece.outfit_component.mouse_in_icon.connect(_on_mouse_in_icon)
		piece.outfit_component.mouse_out_icon.connect(_on_mouse_out_icon)
		piece.outfit_component.mouse_in_attack.connect(_on_mouse_in_attack)
		piece.outfit_component.mouse_out_attack.connect(_on_mouse_out_attack)
	if piece.get_node_or_null("HealthComponent"):
		piece.health_component.death.connect(_on_piece_death)

#endregion

#region 觸發

#選取棋子
func _on_piece_selected(piece: Piece) -> void:
	if not piece_selected: #若目前沒有選定的棋子
		select_piece(piece)
		return
	if piece_selected == piece: #若再選定一次自己則取消選定
		select_piece(null)
		return
	if not piece.is_on_board or piece_selected.is_on_board: #兩個手牌上的棋子 = 交換位置
		swap_piece_in_hand(piece, piece_selected)
		select_piece(null)
		return
	#轉而選定其他的棋子
	select_piece(piece)

#棋子發動攻擊
func _on_piece_attack(piece: Piece) -> void:
	var targets = get_attackable_pieces(piece)
	piece.attack(targets)
	piece_detail.show_piece_detail(piece)

#選取格子時
func _on_tile_clicked(location: Vector2i) -> void:
	if not piece_selected: #沒有先選定棋子
		return
	if piece_selected.location == location: #原地
		return
	
	if not is_on_board(piece_selected.location):
		if is_on_board(location):
			move_piece_to_board(piece_selected, location)
		else:
			move_piece_in_hand(piece_selected, location)
		piece_selected.select_effect(false)
		piece_selected = null
		tilemap.piece_select = null

#滑鼠在棋子圖示上，顯示詳細資料
func _on_mouse_in_icon(piece: Piece) -> void:
	piece_detail.show_piece_detail(piece)
	pass

#滑鼠離開棋子圖示上，不再顯示詳細資料
func _on_mouse_out_icon(piece: Piece) -> void:
	piece_detail.show_piece_detail(piece_selected)
	pass

#滑鼠在攻擊鍵上，顯示攻擊範圍
func _on_mouse_in_attack(piece: Piece) -> void:
	if piece.outfit_component.attack_button.disabled:
		return
	var targets = get_attackable_pieces(piece)
	tilemap.highlight_tiles(piece.get_target_location(targets))

#滑鼠離開攻擊鍵上，不再顯示攻擊範圍
func _on_mouse_out_attack(piece: Piece) -> void:
	tilemap.reset(1)

#棋子死亡時，新增棋子至墓地並將其從場上移除
func _on_piece_death(piece: Piece) -> void:
	board_piece_dic[str(piece.location)] = 0
	graveyard[piece.player].append(piece)
	piece.queue_free()

#切換回合按鍵
func _on_btn_turn_end_1_pressed() -> void:
	end_turn()

func _on_btn_turn_end_0_pressed() -> void:
	end_turn()


#endregion

#region 選定/移動

#選定/取消選定棋子時
func select_piece(piece: Piece) -> void:
	if piece != null: #選定
		if piece_selected != null: #若原本有其他選定的目標，清除選定特效
			piece_selected.select_effect(false)
			tilemap.piece_select = null
		#選定目標，並為格子加上選定特效
		piece_selected = piece
		piece_selected.select_effect(true, piece_selected.is_on_board and piece_selected.player == player_turn)
		tilemap.piece_select = piece
		piece_detail.show_piece_detail(piece_selected)
	else: #取消選定
		if piece_selected == null:
			return
		piece_selected.select_effect(false)
		piece_selected = null
		tilemap.piece_select = null

#移動場上棋子
func move_piece(piece: Piece, location: Vector2i) -> void:
	if not piece.player == player_turn: #不能移動對手的棋子
		return
	if board_piece_dic[str(location)] is not int: #該格子已有棋子
		return

	#預留：檢查是否有移動Buff	
	
	board_piece_dic[str(piece.location)] = 0
	board_piece_dic[str(location)] = piece
	piece.position = tilemap.map_to_local(location)
	piece.location = location

#將手上的棋子放置到場上
func move_piece_to_board(piece: Piece, location: Vector2i) -> void:
	if not piece.player == player_turn: #不能移動對手的棋子
		return
	if board_piece_dic[str(location)] is not int: #該格子已有棋子
		return
	hand_piece_array[piece.player][piece.location.x] = 0
	board_piece_dic[str(location)] = piece
	piece.position = tilemap.map_to_local(location)
	piece.location = location
	piece.is_on_board = true
	piece.on_piece_set()

#移動手上的棋子順序
func move_piece_in_hand(piece: Piece, location: Vector2i) -> void:
	if not piece.player == player_turn: #不能移動對手的棋子
		return
	if not piece.player * 7 == location.y: #不能移動至對手的手牌
		return
	if hand_piece_array[piece.player][location.x] is not int: #該格子已有棋子
		return
	hand_piece_array[piece.player][piece.location.x] = 0
	hand_piece_array[piece.player][location.x] = piece
	piece.position = tilemap.map_to_local(location)
	piece.location = location

#交換兩個棋子
func swap_piece_in_hand(piece1: Piece, piece2: Piece) -> void:
	if piece1.is_on_board or piece2.is_on_board: #場上的棋子不能交換
		return
	if piece1.player != player_turn or piece2.player != player_turn: #不能移動對手的棋子
		return
	var temp = piece1
	var temp_p1_location = piece1.location
	var temp_p2_location = piece2.location
	hand_piece_array[piece1.player][temp_p1_location.x] = piece2
	hand_piece_array[piece1.player][temp_p2_location.x] = temp
	piece1.position = tilemap.map_to_local(temp_p2_location)
	piece2.position = tilemap.map_to_local(temp_p1_location)
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

#可能攻擊對象
func get_attackable_pieces(piece: Piece) -> Array:
	var targets := []
	targets.append_array(p0_pieces.get_children())
	targets.append_array(p1_pieces.get_children())
	#只可攻擊場上棋子
	targets = targets.filter(func(target):
		return target.is_on_board
	)
	return targets
	
#endregion
