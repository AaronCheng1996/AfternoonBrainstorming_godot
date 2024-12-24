extends Piece
class_name MossAPT

var moss = preload("res://script/cards/moss/moss.gd").new()
var rate : int = 50
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.moss.name + Global.data.card.default_name.apt
	description = Global.data.card.moss.apt.format([str(0), str(0), str(0)])

#攻擊額外造成 {0} 點傷害\n[b]攻擊後[/b]：獲得 {1} [img]res://img/UI/buff/rune.png[/img][color='orange']符文[/color]
#\n[b]造成傷害[/b]：獲得 {2} [img]res://img/UI/shield.png[/img][color='orange']護盾[/color]
# (0.5[img]res://img/UI/buff/rune.png[/img]/0.5[img]res://img/UI/sword.png[/img]/0.5[img]res://img/UI/shield.png[/img])

func refresh() -> void:
	var text1 = str(moss.get_rune_count(card_owner) * rate / 100)
	var text2 = str(health_component.shield * rate / 100)
	var text3 = str((moss.get_rune_count(card_owner) * rate / 100 + attack_component.atk) * rate / 100)
	Global.set_font_color(text1, Global.get_font_color(moss.get_rune_count(card_owner) * rate / 100, 0))
	Global.set_font_color(text2, Global.get_font_color(health_component.shield * rate / 100, 0))
	Global.set_font_color(text3, Global.get_font_color((moss.get_rune_count(card_owner) * rate / 100 + attack_component.atk) * rate / 100, attack_component.DEFAULT_ATK))
	description = Global.data.card.moss.apt.format([text1, text2, text3])
	super.refresh()
	
func attack() -> void:
	buff_value_sum = 0
	var temp = attack_component.atk
	attack_component.atk += moss.get_rune_count(card_owner) * rate / 100
	super.attack()
	attack_component.atk = temp
	moss.add_rune(card_owner, health_component.shield * rate / 100)
	shielded(buff_value_sum, self)

func _on_attack_component_on_hit(target: Piece) -> void:
	buff_value_sum += attack_component.atk * rate / 100
