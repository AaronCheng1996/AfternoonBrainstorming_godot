extends Piece
class_name RedHF

var red = preload("res://script/cards/red/red.gd").new()
var cost_value : int = 1
var buff_value : int = 1
var cost_value_sum : int = 0
var buff_value_sum : int = 0

func _init() -> void:
	show_name = Global.data.card.red.name + Global.data.card.default_name.hf
	description = Global.data.card.red.hf.format([str(cost_value), str(buff_value)])

func heal(value: int, applyer) -> int:
	if buff_component.has_buff(Global.data.buff.death_door.name): #有瀕死buff
		if health_component.health + value > 0: #若回復至正常血量則移除瀕死
			buff_component.remove_buff(buff_component.get_buff(Global.data.buff.death_door.name))
	return super.heal(value, applyer)

func attack() -> void:
	cost_value_sum = 0
	buff_value_sum = 0
	super.attack()
	#處理自傷，若因此生命低於0，給予瀕死(回合結束死亡)
	take_damaged(cost_value_sum, self)
	if not buff_component.has_buff(Global.data.buff.death_door.name):
		if health_component.health <= 0:
			var death_door = DeathDoor.new()
			death_door.show_name = Global.data.buff.death_door.name
			death_door.description = Global.data.buff.death_door.description
			death_door.tag.append_array([Global.BuffTag.BUFF])
			death_door.icon_path = Global.buff_icon.death_door
			add_buff(death_door)
	#給予增益
	var attack_buff = red.create_attack_buff(buff_value_sum, card_owner)
	add_buff(attack_buff)

func _on_attack_component_on_hit(target: Piece) -> void:
	cost_value_sum += cost_value
	buff_value_sum += buff_value
