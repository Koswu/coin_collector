extends CharacterBody2D

class_name Player



const SPEED = 300.0
var holding_coin: Coin = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _init():
	pass

func _physics_process(_delta):
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		velocity.y = 0
		$AnimatedSprite2D.play("right")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = - SPEED
		velocity.y = 0
		$AnimatedSprite2D.play("left")
	elif Input.is_action_pressed("ui_up"):
		velocity.y = - SPEED
		velocity.x = 0
		$AnimatedSprite2D.play("up")
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
		velocity.x = 0
		$AnimatedSprite2D.play("down")
	else:
		$AnimatedSprite2D.stop()
		velocity = Vector2.ZERO
	move_and_slide()
	


func try_collect_coin(coin: Coin) -> bool:
	if not holding_coin:
		holding_coin = coin
		return true
	return false

func try_put_coin() -> Coin:
	if holding_coin:
		var coin = holding_coin
		holding_coin = null
		return coin
	return null


