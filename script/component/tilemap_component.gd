extends TileMap

signal tile_selected(tile)
var gird_size = 4
var hand_size = 8
var dic = {}
var mouse_on_button = false
var piece_select = null


func _ready() -> void:
	#生成棋盤
	for x in gird_size:
		for y in gird_size:
			dic[str(Vector2(x + 2, y + 2))] = { "type": "default" }
			set_cell(0, Vector2(x + 2, y + 2), 0, Vector2i(0, 0), 0)
	#生成手上空間
	for x in hand_size:
		dic[str(Vector2(x, 0))] = { "type": "hand" }
		set_cell(0, Vector2(x, 0), 1, Vector2i(0, 0), 0)
		dic[str(Vector2(x, 7))] = { "type": "hand" }
		set_cell(0, Vector2(x, 7), 1, Vector2i(0, 0), 0)


func _process(delta: float) -> void:
	reset(2)
	if piece_select:
		set_cell(2, piece_select.location, 1, Vector2i(0, 0), 0)
		var tile = local_to_map(get_local_mouse_position())
		#有選定棋子，且目的為可移動範圍
		if dic.has(str(tile)) and not tile == piece_select.location and (tile.y == piece_select.player * 7 or (tile.y != 0 and tile.y != 7)):
			set_cell(2, tile, 2, Vector2i(0, 0), 0)

#顯示攻擊對象
func show_attack_target(targets: Array) -> void:
	for target in targets:
		set_cell(1, target, 1, Vector2i(0, 0), 0)

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
