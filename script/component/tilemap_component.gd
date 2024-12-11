extends TileMap

signal tile_selected(tile)
var gird_size = 4
var hand_size = 8
var dic = {}
var piece_select : Piece = null
var current_player : int = -1


func _ready() -> void:
	#生成棋盤
	for x in gird_size:
		for y in gird_size:
			dic[str(Vector2(x + 2, y + 2))] = "board"
	#生成手上空間
	for x in hand_size:
		dic[str(Vector2(x, 0))] = "hand"
		dic[str(Vector2(x, 7))] = "hand"


func _process(delta: float) -> void:
	reset(2)
	if piece_select: #有選定棋子，顯示可動目標
		set_cell(2, piece_select.location, 2, Vector2i(0, 0), 0)
		var tile = local_to_map(get_local_mouse_position())
		if tile == piece_select.location: #排除自己
			return
		if piece_select.player != current_player: #排除對方棋子
			return
		if piece_select.outfit_component: #排除在場上且不能移動時
			if piece_select.outfit_component.move_button.disabled and is_on_board(piece_select.location):
				return
		#顯示可動目標
		if dic.has(str(tile)) and (tile.y == piece_select.player * 7 or (tile.y != 0 and tile.y != 7)):
			set_cell(2, tile, 2, Vector2i(0, 0), 0)

#顯示攻擊對象
func highlight_tiles(targets: Array) -> void:
	for target in targets:
		set_cell(1, target, 2, Vector2i(2, 0), 0)

#清除特定圖層
func reset(layer: int) -> void:
	for x in gird_size:
		for y in gird_size:
			erase_cell(layer, Vector2(x + 2, y + 2))
	for x in hand_size:
		erase_cell(layer, Vector2(x, 0))
		erase_cell(layer, Vector2(x, 7))

#點擊時
func _on_board_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		var tile = local_to_map(get_local_mouse_position())
		if dic.has(str(tile)):
			emit_signal("tile_selected", tile)

#判斷是否在棋盤上
func is_on_board(location: Vector2i) -> bool:
	if location.x >= 2 and location.x <= 5:
		if location.y >= 2 and location.y <= 5:
			return true
	return false
