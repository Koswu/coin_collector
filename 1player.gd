extends CharacterBody2D

var holding_coin = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -1
	elif Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1
	else:
		velocity = Vector2.ZERO
	move_and_collide(velocity * delta)
	


func try_collect_coin() -> bool:
	if not holding_coin:
		holding_coin = true 
		return true
	return false

func try_put_coin() -> bool:
	if holding_coin:
		holding_coin = false
		return true
	return false

