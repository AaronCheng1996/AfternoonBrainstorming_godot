extends Node

#region 基本參數
#規則
var deck_size = 12
var hand_size = 8
var type_limit = 2
var first_turn = 1
var starter_hand_count : int = 4
#棋子
enum PatternNames {CROSS, CROSS_LARGE, X, X_LARGE, NEARBY, NEAREST, FAREST, ALL}
#buff
enum BuffTag {DEBUFF, BUFF, RED}
var buff_icon = {
	"stun": {
		"default": "res://img/UI/buff/stun.png",
		"mini": "res://img/UI/buff_mini/stun_mini.png"
	},
	"sleep": {
		"default": "res://img/UI/buff/sleep.png",
		"mini": "res://img/UI/buff_mini/sleep_mini.png"
	},
	"attack_buff": {
		"default": "res://img/UI/buff/attack_buff.png",
		"mini": "res://img/UI/buff_mini/attack_buff_mini.png"
	},
	"attack_debuff": {
		"default": "res://img/UI/buff/attack_debuff.png",
		"mini": "res://img/UI/buff_mini/attack_debuff_mini.png"
	},
	"health_buff": {
		"default": "res://img/UI/buff/health_buff.png",
		"mini": "res://img/UI/buff_mini/health_buff_mini.png"
	},
	"health_debuff": {
		"default": "res://img/UI/buff/health_debuff.png",
		"mini": "res://img/UI/buff_mini/health_debuff_mini.png"
	},
	"move": {
		"default": "res://img/UI/buff/move.png",
		"mini": "res://img/UI/buff_mini/move_mini.png"
	},
	"rage": {
		"default": "res://img/UI/buff/rage.png",
		"mini": "res://img/UI/buff_mini/rage_mini.png"
	},
	"blue_charge": {
		"default": "res://img/UI/buff/blue_charge.png",
		"mini": "res://img/UI/buff_mini/blue_charge_mini.png"
	},
	"rune": {
		"default": "res://img/UI/buff/rune.png",
		"mini": "res://img/UI/buff_mini/rune_mini.png"
	}
}
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
#玩家資訊
var player_list := []
var winner : int = -1
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
#region 圖片特效
func change_color(picture: Sprite2D, origin: Color, new_color: Color) -> void:
	var image: Image = picture.texture.get_image()
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y) == origin:
				image.set_pixel(x, y, new_color)
	var new_texture = ImageTexture.create_from_image(image)
	picture.texture = new_texture
#endregion
#endregion
