extends Node

#region 基本參數
#規則
var deck_size = 12
var hand_size = 8
var type_limit = 2
var first_turn = 1
var starter_hand_count : int = 4
#棋子
enum PatternNames {CROSS, CROSS_LARGE, X, X_LARGE, NEARBY, NEAREST, FAREST}
#buff
enum BuffTag {DEBUFF, BUFF, RED}
#顯示
var default_score_color : String = "white"
var p0_score_color : String = "red"
var p1_score_color : String = "blue"
#endregion

#region 通用變數
#種子碼、隨機數產生器
var seed : int
var rng = RandomNumberGenerator.new()
#遊戲敘述
var data := {}
#endregion

#region 通用函式
func _ready() -> void:
	var open_err = FileAccess.open("res://setting/description.json", FileAccess.READ)
	var json_object = JSON.new()
	var parse_err = json_object.parse(open_err.get_as_text())
	data = json_object.get_data()
#region 文字特效
#置中文字
func set_font_center(text: String) -> String:
	return "[center]{0}[/center]".format([text])
#文字大小
func set_font_size(text: String, size: int) -> String:
	return "[font_size={0}]{1}[/font_size]".format([str(size), text])
#文字顏色
func set_font_color(text: String, color: String) -> String:
	return "[color={0}]{1}[/color]".format([color, text])
#根據數值選擇文字顏色
func get_font_color(value: int, default_value: int) -> String:
	if value > default_value:
		return "green"
	elif value < default_value:
		return "red"
	return "white"
func get_attack_icon(size = null) -> String:
	if size:
		return "[img=" + size + "]res://img/UI/sword.png[/img]"
	return "[img]res://img/UI/sword.png[/img]"
func get_health_icon(size = null) -> String:
	if size:
		return "[img=" + size + "]res://img/UI/heart.png[/img]"
	return "[img]res://img/UI/heart.png[/img]"
#endregion
#endregion
