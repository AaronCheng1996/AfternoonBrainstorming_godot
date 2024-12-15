extends Control

@onready var board: ColorRect = $board
@onready var tilemap: TileMap = $board/TileMap
@onready var p0_end_button: Button = $board/btn_turn_end_0
@onready var p1_end_button: Button = $board/btn_turn_end_1
@onready var piece_detail: PieceDetail = %piece_detail
@onready var pieces: Node2D = $board/Pieces
@onready var score_label: RichTextLabel = $board/score_label
@onready var message: Label = $message

"""
#hint1：player0遊戲中顯示為player2，為上方玩家；player1遊戲中顯示為player1，下方玩家。
#hint2：由player1先手。
"""

var player_list := []
#場面
var gird_size : int = 4
var board_piece_dic := {}
#選定的棋子
var piece_selected : Piece = null
var mouse_on_attack : bool = false
#當前回合
var current_turn : int = Global.first_turn
#分數
var score_size : int = 60
var score_color : String = Global.default_score_color
var score : int = 0

func _ready() -> void:
	#確認是否有兩位玩家，若無則回到主頁
	if not player_list.size() == 2:
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	#抽上起手牌
	for i in range(Global.starter_hand_count - 1):
		draw_piece(player_list[current_turn])
	for i in range(Global.starter_hand_count):
		if current_turn == 0:
			draw_piece(player_list[1])
		else:
			draw_piece(player_list[0])
	#生成棋盤陣列
	for x in gird_size:
		for y in gird_size:
			board_piece_dic[str(Vector2(x + 2, y + 2))] = 0
	tilemap.tile_selected.connect(_on_tile_clicked)
	#正式開始遊戲
	start_turn(player_list[current_turn])

func _process(delta: float) -> void:
	if mouse_on_attack and piece_selected:
		tilemap.reset(1)
		tilemap.highlight_tiles(piece_selected.get_target_location(pieces.get_children()))

#region 流程

#(給deck_build時外部呼叫)設定雙方牌組
func set_player(new_player_list: Array) -> void:
	player_list = new_player_list

#回合開始
func start_turn(player: Player) -> void:
	tilemap.current_turn = player.id
	#所有場上棋子
	for index in board_piece_dic:
		if board_piece_dic[index] is int:
			continue
		#棋子執行回合開始效果
		board_piece_dic[index].on_turn_start(current_turn, pieces.get_children())
	#抽牌
	draw_piece(player)
	player.attack_count += 1

#回合結束
func end_turn() -> void:
	#所有場上棋子
	for index in board_piece_dic:
		if board_piece_dic[index] is int:
			continue
		var piece = board_piece_dic[index]
		#計分
		score += piece.get_score(current_turn)
		if score < 0:
			score_color = Global.p0_score_color
		elif score > 0:
			score_color = Global.p1_score_color
		else:
			score_color = Global.default_score_color
		score_label.text = Global.set_font_center(Global.set_font_color(Global.set_font_size(str(abs(score)), score_size), score_color))
		#棋子執行回合結束效果
		piece.on_turn_end(current_turn, pieces.get_children())
	#得分超過 10 則獲勝
	if abs(score) >= 10:
		var winner = -1
		if score > 0:
			winner = 0
		else:
			winner = 1
		win(winner)
	else:
		#解除所有鎖定
		select_piece(null)
		#換邊開始回合
		if current_turn == 1:
			current_turn = 0
			p0_end_button.disabled = false
			p1_end_button.disabled = true
		else:
			current_turn = 1
			p0_end_button.disabled = true
			p1_end_button.disabled = false
		start_turn(player_list[current_turn])

#抽牌
func draw_piece(player: Player) -> void:
	if player.deck.size() == 0: #空牌庫
		return
	if player.hand.count(0) <= 0: #手上沒有空間
		return
	
	var piece = player.deck.pop_front()
	pieces.add_child(piece)
	var empty = player.hand.find(0)
	
	piece.position = tilemap.map_to_local(Vector2(empty, player.id * 7))
	piece.location = Vector2(empty, player.id * 7)
	player.hand[empty] = piece
	#設定外觀與連結
	if piece.get_node_or_null("OutfitComponent"):
		piece.outfit_component.set_player_effect(player.id)
		piece.outfit_component.piece_selected.connect(_on_piece_selected)
		piece.outfit_component.piece_attack.connect(_on_piece_attack)
		piece.outfit_component.mouse_in_icon.connect(_on_mouse_in_icon)
		piece.outfit_component.mouse_out_icon.connect(_on_mouse_out_icon)
		piece.outfit_component.mouse_in_attack.connect(_on_mouse_in_attack)
		piece.outfit_component.mouse_out_attack.connect(_on_mouse_out_attack)
	if piece.get_node_or_null("HealthComponent"):
		piece.health_component.death.connect(_on_piece_death)

#勝利
func win(winner: int) -> void:
	#加載並切換到新場景
	var end_scene = preload("res://scenes/end.tscn").instantiate()
	end_scene.set_winner(winner)
	get_parent().add_child(end_scene)
	get_parent().remove_child(self)

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
	if piece.piece_owner.attack_count <= 0: #檢查是否有
		message.pop_message(Global.data.message.no_attack)
		return
	piece.piece_owner.attack_count -= 1 #消耗一次攻擊次數
	#發動攻擊
	piece.attack(pieces.get_children())
	#更新場面訊息
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
		piece_selected.hide_select_effect()
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
	mouse_on_attack = true

#滑鼠離開攻擊鍵上，不再顯示攻擊範圍
func _on_mouse_out_attack(piece: Piece) -> void:
	mouse_on_attack = false
	tilemap.reset(1)

#棋子死亡時，新增棋子至墓地並將其從場上移除
func _on_piece_death(piece: Piece) -> void:
	board_piece_dic[str(piece.location)] = 0
	pieces.remove_child(piece)
	piece.piece_owner.grave.append(piece)

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
			piece_selected.hide_select_effect()
			tilemap.piece_select = null
		#選定目標，並為格子加上選定特效
		piece_selected = piece
		if piece_selected.piece_owner.id == current_turn and piece_selected.is_on_board:
			piece_selected.show_select_effect()
		tilemap.piece_select = piece
		piece_detail.show_piece_detail(piece_selected)
	else: #取消選定
		if piece_selected == null:
			return
		piece_selected.hide_select_effect()
		piece_selected = null
		tilemap.piece_select = null

#移動場上棋子
func move_piece(piece: Piece, location: Vector2i) -> void:
	if not piece.piece_owner.id == current_turn: #不能移動對手的棋子
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
	if not piece.piece_owner.id == current_turn: #不能移動對手的棋子
		return
	if board_piece_dic[str(location)] is not int: #該格子已有棋子
		return
	piece.piece_owner.hand[piece.location.x] = 0
	board_piece_dic[str(location)] = piece
	piece.position = tilemap.map_to_local(location)
	piece.location = location
	piece.is_on_board = true
	piece.on_piece_set(pieces.get_children())

#移動手上的棋子順序
func move_piece_in_hand(piece: Piece, location: Vector2i) -> void:
	if not piece.piece_owner.id == current_turn: #不能移動對手的棋子
		return
	if not piece.piece_owner.id * 7 == location.y: #不能移動至對手的手牌
		return
	if piece.piece_owner.hand[location.x] is not int: #該格子已有棋子
		return
	piece.piece_owner.hand[piece.location.x] = 0
	piece.piece_owner.hand[location.x] = piece
	piece.position = tilemap.map_to_local(location)
	piece.location = location

#交換兩個棋子
func swap_piece_in_hand(piece1: Piece, piece2: Piece) -> void:
	if piece1.is_on_board or piece2.is_on_board: #場上的棋子不能交換
		return
	if piece1.piece_owner.id != current_turn or piece2.piece_owner.id != current_turn: #不能移動對手的棋子
		return
	var temp = piece1
	var temp_p1_location = piece1.location
	var temp_p2_location = piece2.location
	piece1.piece_owner.hand[temp_p1_location.x] = piece2
	piece1.piece_owner.hand[temp_p2_location.x] = temp
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
#endregion
