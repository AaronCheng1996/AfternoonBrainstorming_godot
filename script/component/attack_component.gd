extends Node2D
class_name AttackComponent

signal start_attack(piece: Piece)
signal on_hit(target: Piece)
signal on_kill(target: Piece)

#基礎攻擊與攻擊方式
@export var DEFAULT_ATK := 5
var atk : int
enum PatternNames {CROSS, CROSS_LARGE, X, X_LARGE, NEARBY, NEAREST, FAREST}
@export var ATK_PATTERN : PatternNames

var gird_size = 4

func _ready() -> void:
	atk = DEFAULT_ATK

#發動攻擊
func hit(target) -> void:
	if not target:
		return
	if not target.health_component:
		return
	
	emit_signal("on_hit", target)
	if atk > 0:
		if target.health_component.take_damaged(atk):
			emit_signal("on_kill", target)

#發動攻擊
func attack(pieces: Array) -> void:
	if not pieces: #是否為null
		return
	
	var attacker = get_parent()
	emit_signal("start_attack", get_parent())
	
	if pieces.size() == 0: #是否存在敵方棋子
		return
	
	#最近/最遠
	var targets = []
	if ATK_PATTERN == PatternNames.NEAREST:
		targets = find_target(attacker.location, pieces, true)
	elif ATK_PATTERN == PatternNames.FAREST:
		targets = find_target(attacker.location, pieces, false)
	#處理最近/最遠傷害
	if targets.size() > 0:
		var random_index = randi() % targets.size()
		hit(targets[random_index])
		return
	#AOE
	for piece in pieces:
		if in_attack_range(attacker.location, piece.location):
			hit(piece)

#取得目標區域
func get_target_location(pieces: Array) -> Array:
	var target_location = []
	var attacker = get_parent()
	#最近/最遠
	var targets = []
	if ATK_PATTERN == PatternNames.NEAREST:
		targets = find_target(attacker.location, pieces, true)
	elif ATK_PATTERN == PatternNames.FAREST:
		targets = find_target(attacker.location, pieces, false)
	if targets.size() > 0:
		for piece in targets:
			target_location.append(piece.location)
		return target_location
	#AOE
	for x in gird_size:
		for y in gird_size:
			if in_attack_range(attacker.location, Vector2(x + 2, y + 2)):
				target_location.append(Vector2(x + 2, y + 2))
	
	return target_location

#判斷是否在AOE範圍內
func in_attack_range(location, target_location) -> bool:
	var x = target_location.x
	var y = target_location.y
	match ATK_PATTERN:
		PatternNames.CROSS: #十字
			return abs(x - location.x) + abs(y - location.y) == 1
		PatternNames.CROSS_LARGE: #大十字
			return x == location.x or y == location.y
		PatternNames.X: #X型
			return abs(x - location.x) == 1 and abs(y - location.y) == 1
		PatternNames.X_LARGE: #大X型
			return abs(x - location.x) == abs(y - location.y)
		PatternNames.NEARBY: #九宮格內
			return abs(x - location.x) <= 1 and abs(y - location.y) <= 1
	return false

#尋找目標(最近/最遠)單位
func find_target(location, pieces: Array, is_find_near: bool) -> Array:
	var target = 0
	if is_find_near:
		target = INF
	var distances = []
	distances.resize(pieces.size())
	distances.fill(0)
	#找出最大/最小值
	for i in range(pieces.size()):
		var distance = abs(pieces[i].location.x - location.x) + abs(pieces[i].location.y - location.y)
		distances[i] = distance #紀錄每個目標的距離
		if is_find_near: #找出最小值
			if distance < target:
				target = distance
		else: #找出大值
			if distance > target:
				target = distance
	#選出最大/最小等距的目標
	var result = []
	for i in range(pieces.size()):
		if distances[i] == target:
			result.append(pieces[i])
	
	return result
