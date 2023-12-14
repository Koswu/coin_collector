extends Area2D
class_name Enemy

signal try_steal_player_coin(player: Player)


var speed = 0
var target_node = weakref(null)
var velocity = Vector2.ZERO

func _ready():
	speed = randf_range(100, 280)

func _process(delta):
	var target_position = position if target_node.get_ref() == null else target_node.get_ref().position
	var direction = (target_position - position).normalized()
	velocity = direction * speed
	var position_delta = velocity * delta
	if position_delta.length() > (target_position - position).length():
		position = target_position
	else:
		position += position_delta
	
	var bodys = get_overlapping_bodies()

	for body in bodys:
		if body is Player:
			try_steal_player_coin.emit(body)
	

func idle():
	target_node = weakref(null)

func follow(target: Node2D):
	target_node = weakref(target)

