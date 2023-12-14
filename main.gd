extends Node2D

const COIN_COUNT = 5
const ENEMY_COUNT = 4
var collected_cnt = 0

var viewport_rect 

func _replace_coin(coin: Coin):
	var viewport_size = viewport_rect.size
	coin.position = Vector2(randf_range(0, viewport_size.x), randf_range(0, viewport_size.y))


func _create_coin():
	const coin_scene = preload("res://coin.tscn")
	var coin = coin_scene.instantiate()
	_replace_coin(coin)
	# rand position 
	coin.connect("body_entered", _on_coin_body_entered.bind(coin))
	coin.connect("area_entered", _on_coin_body_entered.bind(coin))
	add_child(coin)

func _create_enemy():
	const enemy_scene = preload("res://enemy.tscn")
	var enemy = enemy_scene.instantiate()
	var viewport = get_viewport_rect()
	# rand position 
	enemy.position = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
	enemy.connect("try_steal_player_coin", _on_enemy_try_steal_player_coin)
	add_child(enemy)
	return enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_rect = get_viewport_rect()
	for i in range(COIN_COUNT):
		_create_coin()

	for i in range(ENEMY_COUNT):
		var enemy = _create_enemy()
		enemy.follow($player)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_coin_body_entered(body: Node2D, coin: Coin):
	if body is Player:
		body = body as Player
		if body.try_collect_coin(coin):
			coin.get_parent().remove_child(coin)
			$coinPickedSound.play()
	elif body is Enemy:
		body = body as Enemy
		_replace_coin(coin)
		$coinMissingSound.play()
	else:
		print("unknown type", body)
		pass



func _on_chest_body_entered(body:Node2D):
	body = body as Player
	if not body:
		return
	var coin = body.try_put_coin()
	if coin:
		$coinCollectedSound.play()
		collected_cnt += 1
		coin = coin as Coin
		coin.queue_free()

	if collected_cnt >= COIN_COUNT:
		collected_cnt = 0
		get_tree().quit()

		


func _on_enemy_try_steal_player_coin(player: Player):
	var coin = player.try_put_coin()
	if coin:
		$coinMissingSound.play()
		_replace_coin(coin)
		add_child(coin)
