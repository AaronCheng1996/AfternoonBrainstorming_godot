extends Control

@onready var piece_detail = preload("res://scenes/UI/piece_detail.tscn")
@onready var pieces = $pieces
@onready var piece_grid: GridContainer = $background/ScrollContainer/piece_grid
@onready var btn_start: Button = $btn_start

var deck_size = 12
var deck := []
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	btn_start.disabled = true
	#建立牌組
	for i in range(2):
		deck.append([])
		#測試用
		create_test_deck(i)
	
	var count = 0
	for i in range(piece_types.size()):
		var piece_scene = load(piece_types[i])
		var new_piece : Piece = piece_scene.instantiate()
		pieces.add_child(new_piece)
		var new_piece_detail = piece_detail.instantiate()
		piece_grid.add_child(new_piece_detail)
		new_piece_detail.show_piece_detail(new_piece)
		#new_piece_detail.position = Vector2(10 + (i % 3) * 250, 10 + (i / 3) * 310)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if deck.size() == 2:
		if deck[0].size() == deck_size and deck[1].size() == deck_size:
			btn_start.disabled = false

func _on_start_button_pressed() -> void:
	var match_scene = preload("res://scenes/match.tscn").instantiate()
	match_scene.set_deck(deck)
	get_tree().root.add_child(match_scene)


func create_test_deck(player: int) -> void:
	for i in range(deck_size):
		var random_index = randi() % piece_types.size()
		var piece_scene = load(piece_types[random_index])
		var new_piece = piece_scene.instantiate()
		new_piece.player = player
		new_piece.is_on_board = false

		deck[player].append(new_piece)
