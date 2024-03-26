
extends Node

const SAVE_FILE_PATH = "user://save_file.tres"

var score = 0
var game_data = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	load_data()

func save_data():
	var file = File.new()
	file.open(SAVE_FILE_PATH, File.WRITE)
	file.store_var(game_data)
	file.close()

func load_data():
	var file = File.new()
	if not file.file_exists(SAVE_FILE_PATH):
		game_data = {
			"high_score": 0,
			"asteroid_volume": 0,
			"enemy_volume": 0,
			"player_destroyed_volume": 0,
			"laser_volume": 0,
			"player_hurt_volume": 0
		}
		save_data()
	file.open(SAVE_FILE_PATH, File.READ)
	game_data = file.get_var()
	file.close()
