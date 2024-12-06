extends Control

@onready var card_scene = preload("res://scenes/piece_card.tscn")
@onready var card_grid = $Cards
@onready var btn_start = $btn_start

var deck_size = 12
var deck := []

var offset = Vector2(0, 0)

var piece_type = [
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
	
	for i in range(12):
		var new_card = card_scene.instantiate()
		new_card.global_position = Vector2((i % 3) * 230, (i / 3) * 120) + offset
		card_grid.add_child(new_card)

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
		var random_index = randi() % piece_type.size()
		var piece_scene = load(piece_type[random_index])
		
		var new_piece = piece_scene.instantiate()
		new_piece.player = player
		new_piece.is_on_board = false

		deck[player].append(new_piece)
