extends Node2D


onready var player = $Player
onready var navigation = $Navigation2D

var asteroid = preload("res://scenes/asteroid/Asteroid.tscn")
var asteroid_speed = 120
var big_asteroid_count = 0
var small_asteroid_count = 0
var big_asteroid_limit = 150
var small_asteroid_limit = 100
var enemy_limit = 40
var enemy_count = 0

var rng = RandomNumberGenerator.new()

func _ready():
	get_viewport().set_size(Vector2(1920,1080))
	player.connect("player_damaged", get_node("Scores"), "player_damaged")
	spawn_asteroids_at_ready()

func spawn_asteroids_at_ready():
	for i in big_asteroid_limit:
		rng.randomize()
		var newAsteroid = asteroid.instance()
		var newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		while(player.position.distance_squared_to(newPosition) < 5000):
			newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		set_asteroid_pos_and_vel(newAsteroid,newPosition)
		newAsteroid.connect("asteroid_destroyed", self, "asteroid_destroyed")
		newAsteroid.connect("asteroid_destroyed", get_node("Scores"),"asteroid_destroyed")
		add_child(newAsteroid)
	big_asteroid_count = big_asteroid_limit

func spawn_big_asteroid():
	if big_asteroid_count < big_asteroid_limit:
		rng.randomize()
		var newAsteroid = asteroid.instance()
		var newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		while(player.position.distance_squared_to(newPosition) < 5000):
			newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		set_asteroid_pos_and_vel(newAsteroid,newPosition)
		newAsteroid.connect("asteroid_destroyed", self, "asteroid_destroyed")
		newAsteroid.connect("asteroid_destroyed", get_node("Scores"),"asteroid_destroyed")
		add_child(newAsteroid)
		big_asteroid_count += 1


func asteroid_destroyed(destroyed_asteroid):
	SoundManager.get_node("HitSound").position = destroyed_asteroid.position
	SoundManager.get_node("HitSound").play()
	if destroyed_asteroid.is_big:
		big_asteroid_count -= 1
		spawn_big_asteroid()
		if small_asteroid_count < small_asteroid_limit and rng.randf() <= 0.33:
			for i in rng.randi_range(2,3):
				rng.randomize()
				var small_asteroid = asteroid.instance()
				small_asteroid.is_big = false
				set_asteroid_pos_and_vel(small_asteroid, destroyed_asteroid.position + Vector2(rng.randi_range(-10,10),rng.randi_range(-10,10)))
				small_asteroid.connect("asteroid_destroyed", self, "asteroid_destroyed")
				small_asteroid.connect("asteroid_destroyed", get_node("Scores"),"asteroid_destroyed")
				add_child(small_asteroid)
	else:
		small_asteroid_count -= 1
		

func set_asteroid_pos_and_vel(_asteroid, position):
	_asteroid.position = position
	var angle = randf() * PI * 2 
	var direction = Vector2(cos(angle), sin(angle))
	_asteroid.velocity = direction * asteroid_speed 

func spawn_enemy():
	if enemy_count < enemy_limit:
		var enemy = load("res://scenes/enemy/small_enemy/SmallEnemy.tscn").instance()
		navigation.add_child(enemy)
		enemy.connect("enemy_ship_destroyed", get_node("Scores"), "enemy_ship_destroyed")
		enemy.connect("enemy_ship_destroyed", self, "enemy_ship_destroyed")
		var newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		while(player.position.distance_squared_to(newPosition) < 102400):
			newPosition = Vector2(rng.randf_range(0, 5120),rng.randf_range(0,2880))
		enemy.position = newPosition
		enemy_count += 1


func _on_Timer_timeout():
	spawn_enemy()


func enemy_ship_destroyed(enemy):
	SoundManager.get_node("EnemyDeathSound").position = enemy.position
	SoundManager.get_node("EnemyDeathSound").play()

func _on_Player_player_killed():
	get_tree().paused = true
	$Scores/GameOver.rect_position = Vector2((get_viewport().get_visible_rect().size.x/2)-($Scores/GameOver.rect_size.x)/4,(get_viewport().get_visible_rect().size.y/2) - ($Scores/GameOver.rect_size.y)/4)
	$Scores/GameOver/ExitButton.rect_position =  Vector2((get_viewport().get_visible_rect().size.x/3)-($Scores/GameOver.rect_size.x)/2.8,(get_viewport().get_visible_rect().size.y/2) + ($Scores/GameOver.rect_size.y)/4)
	$Scores/GameOver/ReplayButton.rect_position =  Vector2((get_viewport().get_visible_rect().size.x/2),(get_viewport().get_visible_rect().size.y/2) + ($Scores/GameOver.rect_size.y)/4)
	$Scores/GameOver.popup()
