extends Node2D

var asteroid = preload("res://scenes/asteroid/Asteroid.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().set_size(Vector2(1920,1080))
	for i in 7:
		var newAsteroid = asteroid.instance()
		var newPosition = Vector2(rng.randf_range(100, 500),rng.randf_range(50,300))
		set_asteroid_pos_and_vel(newAsteroid,newPosition)
		add_child(newAsteroid)

func set_asteroid_pos_and_vel(_asteroid, position):
	_asteroid.position = position
	var angle = randf() * PI * 2 
	var direction = Vector2(cos(angle), sin(angle))
	_asteroid.velocity = direction * 60


func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")


func _on_SettingsButton_pressed():
	get_tree().change_scene("res://scenes/menu/Settings.tscn")
