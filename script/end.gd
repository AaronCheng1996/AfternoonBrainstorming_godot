extends Control

@onready var lbl_winner: Label = $lbl_winner
@onready var btn_next: Button = $btn_next

var winner : int

func _ready() -> void:
	lbl_winner.text = "player {0} win!".format([str(winner)])

func set_winner(the_winner: int) -> void:
	winner = the_winner + 1

func _on_btn_next_pressed() -> void:
	get_parent().remove_child(self)
